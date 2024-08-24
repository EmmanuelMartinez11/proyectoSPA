import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_flutter/widgets/ingresar_registrar/ingresar.dart';
import 'firebase_options.dart';
import 'widgets/inicio/inicio.dart';
import 'widgets/servicios/servicios.dart';
import 'widgets/servicios/comentarios.dart';
import 'widgets/servicios/consultas.dart';
import 'package:proyecto_flutter/widgets/ingresar_registrar/registrar_cliente.dart';
import 'package:proyecto_flutter/widgets/ingresar_registrar/registrar_personal.dart';

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
        '/ingresar': (context) => LoginScreen(),
        '/registrar_cliente': (context) => RegistrarCliente(),
        '/registrar_personal': (context) => RegistrarPersonal(),
        '/comentarios': (context) => Comentarios(),
        '/consultas': (context) => Consultas(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userType =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Text(
          'Tipo de Usuario: $userType',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
