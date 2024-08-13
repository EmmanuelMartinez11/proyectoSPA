import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_flutter/firebase_options.dart';
import 'widgets/ingresar/ingresar.dart';
import 'widgets/inicio/inicio.dart';
import 'widgets/servicios/servicios.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute:
          '/inicio', // Define la página de inicio como la ruta inicial
      routes: {
        '/inicio': (context) => Inicio(),
        '/servicios': (context) => Servicios(),
        '/ingresar': (context) => Ingresar(),
      },
    );
  }
}
