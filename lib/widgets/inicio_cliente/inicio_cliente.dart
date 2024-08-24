import 'package:flutter/material.dart';
import 'sacar_turno.dart';
import 'turnos_cliente.dart';
import 'proximo_turno.dart'; // Importa el nuevo archivo

class ClienteScreen extends StatelessWidget {
  final String nombres;
  final String apellidos;

  ClienteScreen({required this.nombres, required this.apellidos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido $nombres $apellidos'),
      ),
      body: Column(
        children: <Widget>[
          SacarTurnoButton(nombres: nombres, apellidos: apellidos),
          ProximoTurno(
              nombres: nombres, apellidos: apellidos), // Añade el widget aquí
          Expanded(
            child: TurnosClienteTable(nombres: nombres, apellidos: apellidos),
          ),
        ],
      ),
    );
  }
}
