import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prontin/services/users_services.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';

void main() async {
  //assincrono para nao aguardar resposta do FB
  WidgetsFlutterBinding.ensureInitialized();

  //configuração para inicialização da aplicação na web
  var options = const FirebaseOptions(
      apiKey: "AIzaSyAmX4xh6Ot-82I6FVnd4CLkZ05VYMD6Z1E",
      projectId: "prontin-b4b5f",
      messagingSenderId: "79635579998",
      appId: "1:79635579998:web:78203e29103871b7d4a0cf");

  //configuração para inicialização da aplicação em disp. moveis
  if (kIsWeb) {
    await Firebase.initializeApp(options: options);
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //notficia as alterações
      providers: [
        ChangeNotifierProvider<UsersServices>(
          create: (_) => UsersServices(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Prontin',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(11, 116, 116, 1.000),
          fontFamily: 'Questrial',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            bodySmall: TextStyle(color: Colors.white),
          ),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 111, 190, 190)),
          useMaterial3: true,
        ),
        home: LoginPage(),
      ),
    );
  }
}
