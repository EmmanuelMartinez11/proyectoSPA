import 'package:flutter/material.dart';
import 'sacar_turno.dart';
import 'turnos_cliente.dart';
import 'proximo_turno.dart'; // Importa el nuevo archivo
import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteScreen extends StatelessWidget {
  final DocumentSnapshot clienteDoc;

  ClienteScreen({required this.clienteDoc});

  @override
  Widget build(BuildContext context) {
    // Accede a los datos del cliente desde clienteDoc
    String nombres = clienteDoc['nombres'];
    String apellidos = clienteDoc['apellidos'];

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
