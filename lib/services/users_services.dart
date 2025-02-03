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
      print("Usuário autenticado: ${user!.uid}");
      await _loadingCurrentUser(user: user);
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
}
