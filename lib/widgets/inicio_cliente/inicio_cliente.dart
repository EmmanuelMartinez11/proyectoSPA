import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sacar_turno.dart';
import 'turnos_cliente.dart';
import 'proximo_turno.dart';
import '../navbar.dart'; // Importa el NavBar

class ClienteScreen extends StatelessWidget {
  final String nombres;
  final String apellidos;

  ClienteScreen({required this.nombres, required this.apellidos});

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(16.0), // Añade un poco de espacio alrededor del mensaje
              child: Text(
                'Bienvenido $nombres $apellidos',
                style: GoogleFonts.dancingScript(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        SacarTurnoButton(nombres: nombres, apellidos: apellidos),
                        SizedBox(height: 20),
                        ProximoTurno(nombres: nombres, apellidos: apellidos),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TurnosClienteTable(nombres: nombres, apellidos: apellidos),
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
