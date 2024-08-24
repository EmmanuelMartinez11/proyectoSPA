import 'package:flutter/material.dart';

class PersonalScreen extends StatelessWidget {
  final String nombres;
  final String apellidos;

  PersonalScreen({required this.nombres, required this.apellidos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido'),
      ),
      body: Center(
        child: Text(
          'Bienvenido $nombres $apellidos',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
