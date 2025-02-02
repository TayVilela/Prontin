import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:prontin/models/users.dart';

class UsersServices {
  final FirebaseAuth _auth = FirebaseAuth.instance; //instancia do firebaseauth
  final FirebaseFirestore _firestore = FirebaseFirestore
      .instance; //instancia do firebasestore p/ se comunicar com firebase
  Users users = Users();

  DocumentReference get _firestoreRef => _firestore.doc(
      'users/${users.id}'); //metodo para pegar referencai e criar firestore

  // metodo para REGISTRAR o usuario no firebase
  Future<bool> signUp(String email, String password, String name,
      String username, String birthday, String gender) async {
    //criação do usuario
    try {
      User? user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      users.id = user!.uid;
      users.email = email;
      users.userName = username;
      users.name = name;
      users.gender = gender;
      users.birthday = birthday;
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

  Future<bool> signIn(
      {String? email,
      String? password,
      Function? onSucess,
      Function? onFail}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      onSucess!();
      return Future.value(true);
    } on FirebaseAuthException catch (e) {
      String code;
      if (e.code == 'invalid-email') {
        code = 'Oopa! Parece que esse e-mail é inválido :/';
      } else if (e.code == 'wrong-password') {
        code = 'Pow, essa senha tá errado..';
      } else if (e.code == '"user-not-found') {
        code = 'Ihh, esse e-mail eu não conheço.';
      } else {
        code = 'Eita, tem coisa errada aí..';
      }
      //objeto para texto
      onFail!(code);
      return Future.value(false);
    }
  }

  //salvar dados do usuario no Firestore p gravar dados
  saveUsersDetails() async {
    await _firestoreRef.set(users.toJson());
  }
}
