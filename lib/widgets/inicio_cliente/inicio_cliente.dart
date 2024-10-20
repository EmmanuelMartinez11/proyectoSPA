import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sacar_turno.dart';
import 'turnos_cliente.dart';
import 'proximo_turno.dart';
import 'comprobante.dart';  // Importa la pantalla para generar el comprobante
import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteScreen extends StatelessWidget {
  final DocumentSnapshot clienteDoc;

  ClienteScreen({required this.clienteDoc});

  @override
  Widget build(BuildContext context) {
    String nombres = clienteDoc['nombres'];
    String apellidos = clienteDoc['apellidos'];

    Color fondoColor = const Color.fromARGB(166, 244, 143, 177);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Volver al inicio'),
        backgroundColor: fondoColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: fondoColor,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Bienvenido $nombres $apellidos',
                style: GoogleFonts.greatVibes(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(238, 124, 168, 119),
                  shadows: [
                    const Shadow(
                      blurRadius: 4.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
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
                        SacarTurnoButton(nombres: nombres, apellidos: apellidos),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Navega a la pantalla de generar comprobante
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GenerarComprobanteScreen(
                                  nombres: nombres,
                                  apellidos: apellidos,
                                ),
                              ),
                            );
                          },
                          child: const Text('Generar Comprobante'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 50.0),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(228, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TurnosClienteTable(
                          nombres: nombres,
                          apellidos: apellidos,
                        ),
                      ),
                    ),
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
