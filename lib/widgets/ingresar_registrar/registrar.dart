import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Registrar extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Registrar> {
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  String _userType = 'cliente'; // Default to 'cliente'

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection('usuarios') // Cambio de 'clientes' a 'usuarios'
          .doc(userCredential.user!.uid)
          .set({
        'nombres': _nombresController.text,
        'apellidos': _apellidosController.text,
        'fecha_nacimiento': _fechaNacimientoController.text,
        'email': _emailController.text,
        'telefono': _telefonoController.text,
        'tipo_usuario': _userType, // Agregar el tipo de usuario
      });

      Navigator.pushReplacementNamed(context, '/inicio');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Usuario')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nombresController,
              decoration: InputDecoration(labelText: 'Nombres'),
            ),
            TextField(
              controller: _apellidosController,
              decoration: InputDecoration(labelText: 'Apellidos'),
            ),
            TextField(
              controller: _fechaNacimientoController,
              decoration: InputDecoration(labelText: 'Fecha de Nacimiento'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _telefonoController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButton<String>(
              value: _userType,
              onChanged: (String? newValue) {
                setState(() {
                  _userType = newValue!;
                });
              },
              items: <String>['cliente', 'administrador']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Selecciona el tipo de usuario'),
            ),
            ElevatedButton(
              onPressed: _register,
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
