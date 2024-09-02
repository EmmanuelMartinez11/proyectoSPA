import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Añadir Provider
import 'firebase_options.dart';
import 'widgets/inicio/inicio.dart';
import 'widgets/servicios/servicios.dart';
import 'widgets/servicios/comentarios.dart';
import 'widgets/servicios/consultas.dart';
import 'package:proyecto_flutter/widgets/ingresar_registrar/ingresar.dart';
import 'package:proyecto_flutter/widgets/ingresar_registrar/registrar_cliente.dart';
import 'package:proyecto_flutter/widgets/ingresar_registrar/registrar_personal.dart';
import 'widgets/user_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserState(), // Proveer el estado del usuario
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
      initialRoute: '/inicio',
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
      },
    );
  }
}
