import 'package:flutter/material.dart';
import 'package:prontin/services/users_services.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(11, 116, 116, 1.000),
      appBar: AppBar(
        title: const Text(
          "Meu perfil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.teal[700],
      ), // Fundo da página
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Consumer<UsersServices>(
          builder: (context, usersServices, child) {
            // Verifica se o usuário já foi carregado
            if (usersServices.users == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: Container(
                padding: const EdgeInsets.all(25),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Fundo branco
                  borderRadius:
                      BorderRadius.circular(15), // Cantos arredondados
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5), // Sombra leve
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Foto do usuário
                    ClipOval(
                      child: Image.asset(
                        'assets/images/simbolo_prontin.png',
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Nome do usuário
                    Text(
                      usersServices.users!.name ?? "Nome não disponível",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Nome de usuario
                    Text(
                      "@${usersServices.users!.userName ?? "Não disponível"}",
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 5),

                    // Email do usuário
                    Text(
                      " ${usersServices.users!.email ?? "Não disponível"}",
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 15),

                    // Botão de editar perfil (futuro)
                    ElevatedButton.icon(
                      onPressed: () {
                        // Implementar navegação para tela de edição do perfil
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text("Editar Perfil"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromRGBO(11, 116, 116, 1.000),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}




/*import 'package:flutter/material.dart';
import 'package:prontin/services/users_services.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Edição do Perfil de Usuário'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Consumer<UsersServices>(
          builder: (context, usersServices, child) {
            // Verifica se os dados do usuário já foram carregados
            if (usersServices.users == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                const Text(
                  "Perfil de Usuário",
                  style: TextStyle(
                    color: Color.fromARGB(255, 2, 32, 3),
                    fontSize: 28,
                    fontFamily: 'Lustria',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Card(
                  elevation: 1.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15,
                    ),
                    child: Row(children: [
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Nome: ${usersServices.users!.userName?.toUpperCase() ?? "Desconhecido"}'),
                          Text(
                              'Email: ${usersServices.users!.email ?? "Sem email"}'),
                        ],
                      )
                    ]),
                  ),
                ),
                GestureDetector(
                  //onTap: () => Navigator.pushNamed(context, '/userprofileedit'),
                  child: const Card(
                    elevation: 1.0,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_add_alt_1_outlined,
                            size: 90.0,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
*/