import 'package:flutter/material.dart';
import 'package:prontin/pages/userprofile_page.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(67, 152, 152, 1),
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logotipo_prontin.png',
              height: 35,
              fit: BoxFit.contain, //proporção da imagem
            ),
          ],
        ),
      ),
      body: [
        //item 1 do bottomNavigation (quadros)
        Center(
            child: Container(
          color: const Color.fromRGBO(241, 221, 136, 1.000),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text("Página de Quadros")],
          ),
        )),

        //item 2 do bottomNavigation (bloco de notas)
        const Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("Página de Bloco de Notas")],
        )),

        //item 3 do bottomNavigation (perfil do user)
        const Center(
          child: UserProfilePage(),
        )
      ][_index],

      //destinos do bottmNavigt
      bottomNavigationBar: NavigationBar(
          selectedIndex: _index, //define o indice ou a pagina atual

          //atualização de indice
          onDestinationSelected: (int position) {
            setState(() {
              _index = position;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.space_dashboard_rounded),
              label: 'Quadros',
            ),
            NavigationDestination(
              icon: Icon(Icons.sticky_note_2_rounded),
              label: 'Blocos de Notas',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_2_rounded),
              label: 'Perfil',
            ),
          ]),
    );
  }
}
