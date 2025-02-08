import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:prontin/models/users.dart';

class UsersServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance; //instancia do firebaseauth
  final FirebaseFirestore _firestore = FirebaseFirestore
      .instance; //instancia do firebasestore p/ se comunicar com firebase

  Users? users;

  DocumentReference get _firestoreRef => _firestore.doc(
      'users/${users!.id}'); //metodo para pegar referencai e criar firestore

  UsersServices() {
    print("Inicializando UsersServices...");
    print("Usuário autenticado? ${_auth.currentUser?.uid}");
    _loadingCurrentUser();
    listenForEmailChange(); // Agora escutamos mudanças no e-mail
  }

  // metodo para REGISTRAR o usuario no firebase
  Future<bool> signUp(String email, String password, String name,
      String username, String birthday, String gender) async {
    //criação do usuario
    try {
      User? user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      users!.id = user!.uid;
      users!.email = email;
      users!.userName = username;
      users!.name = name;
      users!.gender = gender;
      users!.birthday = birthday;
      saveUsersDetails();
      return Future.value(true);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        debugPrint('Oopa! Parece que esse e-mail é inválido :/');
      } else if (error.code == 'weak-password') {
        debugPrint(
            'Pow, essa senha tá fraquinha, usa 6 caracteres pelo menos..');
      } else if (error.code == 'email-already-in-use') {
        debugPrint('Ihh, esse e-mail já tá sendo usado.');
      } else {
        debugPrint('Eita, tem coisa errada aí..');
      }
      return Future.value(false);
    }
  }

  //Método para autenticação de usuário
  Future<void> signIn(
      {String? email,
      String? password,
      Function? onSucess,
      Function? onFail}) async {
    try {
      print("Tentando autenticar usuário com email: $email");
      User? user = (await _auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      ))
          .user;
      await _loadingCurrentUser(user: user);
      print("Usuário autenticado: ${user!.uid}");
      onSucess!();
      // return Future.value(true);
    } on FirebaseAuthException catch (e) {
      String code;
      if (e.code == 'invalid-email') {
        code = 'Email informado é inválido';
      } else if (e.code == 'wrong-password') {
        code = 'A senha informada está errada';
      } else if (e.code == 'user-disabled') {
        code = 'Já existe cadastro com este email!!';
      } else {
        code = "Algum erro aconteceu na Plataforma do Firebase";
      }
      onFail!(code);
      // return Future.value(false);
    }
  }

  //salvar dados do usuario no Firestore p gravar dados
  saveUsersDetails() async {
    await _firestoreRef.set(users!.toJson());
  }

  //método para obter as credenciais do usuário autenticado
  _loadingCurrentUser({User? user}) async {
    print("Chamando _loadingCurrentUser()...");
    User? currentUser = user ?? _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot docUser =
          await _firestore.collection('users').doc(currentUser.uid).get();
      print(
          "Usuário encontrado no Firebase? ${docUser.exists}"); // Verifica se o documento existe
      users = Users.fromJson(docUser);
      notifyListeners();
    } else {
      print("Nenhum dado encontrado para este usuário.");
      users = Users(
          email: 'anonimo@anonimo.com',
          id: currentUser?.uid,
          userName: 'anônimo');
    }
  }

  // Método para atualizar os dados do perfil do usuário
  Future<void> updateUserProfile(
    String name,
    String username,
    String email,
    String birthday,
    String gender,
  ) async {
    if (users == null || users!.id == null) return;

    try {
      User? user = _auth.currentUser;

      // Se o email for diferente, precisamos atualizar no Authentication
      if (user != null && email != user.email) {
        await user.verifyBeforeUpdateEmail(email);
      }

      // Atualiza os dados no Firestore
      await _firestore.collection('users').doc(users!.id).update({
        'name': name,
        'userName': username,
        'email': email,
        'birthday': birthday,
        'gender': gender,
      });

      // Atualiza os dados localmente
      users!.name = name;
      users!.userName = username;
      users!.email = email;
      users!.birthday = birthday;
      users!.gender = gender;

      notifyListeners(); // Atualiza a interface
    } catch (e) {
      debugPrint("Erro ao atualizar perfil: $e");
    }
  }

  Future<void> listenForEmailChange() async {
    _auth.userChanges().listen((User? user) async {
      print("📢 Detectando mudanças no usuário...");

      if (user != null) {
        print("✅ Novo e-mail detectado: ${user.email}");

        // Verifica se o e-mail no Firestore já está atualizado
        print("🔍 E-mail atual no Firestore: ${users?.email}");

        if (user.email != users?.email) {
          print("🚀 Atualizando e-mail no Firestore para: ${user.email}");
          await _firestore.collection('users').doc(users!.id).update({
            'email': user.email!,
          });

          // Atualiza o objeto local do usuário
          users!.email = user.email!;
          notifyListeners();

          print("🎉 E-mail atualizado no Firestore com sucesso!");
        } else {
          print("⚠️ O e-mail no Firestore já está atualizado.");
        }
      } else {
        print("❌ Nenhum usuário autenticado.");
      }
    });
  }

  // Método para excluir a conta do usuário
  Future<void> deleteUserAccount() async {
    if (users == null || users!.id == null) return;

    try {
      // Exclui os dados do Firestore
      await _firestore.collection('users').doc(users!.id).delete();

      // Exclui a conta do Firebase Authentication
      await _auth.currentUser!.delete();

      // Reseta os dados locais
      users = null;

      notifyListeners(); // Atualiza a interface
    } catch (e) {
      debugPrint("Erro ao excluir conta: $e");
    }
  }

  // Método para alterar a senha do usuário autenticado
  Future<String?> changePassword(
      String currentPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        return "Usuário não autenticado.";
      }

      // Reautenticar usuário antes de alterar a senha
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      return null; // Indica que a alteração foi bem-sucedida
    } catch (e) {
      return e
          .toString(); // Retorna o erro como string para ser tratado na View
    }
  }
}
