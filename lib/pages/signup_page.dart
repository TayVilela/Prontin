import 'package:flutter/material.dart';
import 'package:prontin/pages/login_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width; //descobre a largura da tela
    return Scaffold(
      backgroundColor: const Color.fromRGBO(11, 116, 116, 1.000),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0), //espaçamento nas bordas
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, //alinhamento do eixe principal
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logotipo_prontin.png',
                    height: 300,
                    width: screenWidth * 0.8,
                    fit: BoxFit.contain, //proporção da imagem
                  ),
                ],
              ),
              //espaçamento com SizedBox
              const SizedBox(
                height: 20,
              ),
              const Text("Crie seu cadastro *",
                  style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'LazyDog',
                      color: Color.fromRGBO(241, 221, 136, 1.000))),

              //campo nome
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Nome",
                      style: TextStyle(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.7, color: Colors.white))),
              ),

              const SizedBox(
                height: 10,
              ),

              //campo email
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    label: Text(
                      "E-mail",
                      style: TextStyle(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.7, color: Colors.white))),
              ),

              const SizedBox(
                height: 10,
              ),

              // campo senha
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.key,
                      color: Colors.white,
                    ),
                    suffixIcon: Icon(
                      Icons.remove_red_eye_rounded,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Senha",
                      style: TextStyle(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.7, color: Colors.white))),
              ),

              const SizedBox(
                height: 20,
              ),

              //botao login
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 1.5,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text("Cadastro",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        )),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "ou",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),

              //botao login com google
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 1.5,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/google.png', height: 20),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Cadastro com Google",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        )),
                  ],
                ),
              ),

              const SizedBox(
                height: 5,
              ),

              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Já tenho uma conta",
                        style:
                            TextStyle(color: Color.fromRGBO(255, 225, 0, 1))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
