import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_flutter/widgets/navbar.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('../assets/images/inicio/back.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            NavBar(),
            Padding(
              padding: const EdgeInsets.all(
                  16.0), // Añade un poco de espacio alrededor del mensaje
              child: Text(
                'Bienvenido $nombres $apellidos',
                style: GoogleFonts.greatVibes(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        ProximoTurno(nombres: nombres, apellidos: apellidos),
                        const SizedBox(height: 20),
                        SacarTurnoButton(
                            nombres: nombres, apellidos: apellidos),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TurnosClienteTable(
                        nombres: nombres, apellidos: apellidos),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
