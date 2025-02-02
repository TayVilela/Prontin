import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Perfil do Usuario', //titulo na pagina
            style: TextStyle(
                color: Color.fromRGBO(241, 221, 136, 1.000),
                fontSize: 25,
                fontWeight: FontWeight.w700),
          ),

          const SizedBox(
            height: 30,
          ),
          //card de foto e nome do usuario
          Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Row(children: [
                  const SizedBox(
                    width: 12,
                  ),
                  ClipOval(
                    //foto do usuario
                    child: Image.asset(
                      'assets/images/simbolo_prontin.png',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(
                    width: 15,
                  ),

                  //nome do usuario
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Taylla Vilela',
                        style: TextStyle(
                            color: Color.fromRGBO(67, 152, 152, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )
                    ],
                  ),

                  const SizedBox(
                    width: 15,
                  ),

                  //editar perfil do usuario
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.create_rounded),
                    ],
                  )
                ]),
              )),

          //card de configurações
          const Card(
              elevation: 1,
              child: Row(
                children: [
                  Icon(Icons.build_circle_rounded, size: 50),
                  SizedBox(width: 15),
                  Text(
                    "Configurações",
                    style: TextStyle(
                        color: Color.fromRGBO(67, 152, 152, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
