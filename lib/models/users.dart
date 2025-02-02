//classe de dados (DTO) que fará a transferencia de dados (uma classe p outra)
import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String? id;
  String? userName;
  String? email;
  String? password;
  String? name;
  String? birthday;
  String? gender;
  String? image;

  //metodo construtor
  Users({
    this.id,
    this.userName,
    this.email,
    this.name,
    this.password,
    this.birthday,
    this.gender,
    this.image
});

  //metodo que converte os dados para formato mapa (compativel do Json)
  Map<String, dynamic> toJson() {
    return {
      //chave (String) : valor (dynamic)
      'id': id,
      'userName': userName,
      'email': email,
      'name': name,
      'birthday': birthday,
      'gender': gender,
    };
  }

  //método construtor para converter dados do objeto do tipo documento do firebase
  //em formato compatível com o Objeto Users (esta própria classe)
  Users.fromJson(DocumentSnapshot doc) {
    id = doc.id;
    userName = doc.get('userName');
    email = doc.get('email');
    name = doc.get('name');
    gender = doc.get('gender');
    birthday = doc.get('birthday');
    image = doc.get('image');
  }
}
