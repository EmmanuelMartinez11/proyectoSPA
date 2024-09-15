import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importa GoogleFonts para la tipografía
import 'package:proyecto_flutter/widgets/navbar.dart'; // Asegúrate de tener un NavBar similar al de Cliente
import 'turnos_personal.dart';
import 'proximo_turno_personal.dart';
import 'consultas_personal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalScreen extends StatelessWidget {
  final DocumentSnapshot personalDoc;

  PersonalScreen({required this.personalDoc});

  @override
  Widget build(BuildContext context) {
    String nombres = personalDoc['nombres'];
    String apellidos = personalDoc['apellidos'];
    String rolPersonal = personalDoc['rol'];

    String servicio;
    switch (rolPersonal) {
      case 'Masajista':
        servicio = 'Masajes';
        break;
      case 'Esteticista':
        servicio = 'Belleza';
        break;
      case 'Especialista en facial':
        servicio = 'Tratamientos Faciales';
        break;
      case 'Especialista en tratamientos corporales':
        servicio = 'Tratamientos Corporales';
        break;
      default:
        servicio = 'No definido';
    }
    print('Rol Personal: $rolPersonal');
    print('Servicio: $servicio');

    return Scaffold(
      body: Container(
        // Contenedor principal con imagen de fondo
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            NavBar(), // Barra de navegación similar a la de Cliente
            Padding(
              // Mensaje de bienvenida con estilo similar
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Bienvenido $nombres $apellidos',
                style: GoogleFonts.greatVibes(
                  // Usa la misma tipografía
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
                height: 30), // Espacio entre el mensaje y el contenido
            Expanded(
              child: DefaultTabController(
                // Usa DefaultTabController para las pestañas
                length: 2,
                child: Column(
                  children: <Widget>[
                    TabBar(
                      // Barra de pestañas
                      tabs: [
                        Tab(text: 'Turnos'),
                        Tab(text: 'Consultas'),
                      ],
                    ),
                    Expanded(
                      // Contenido de las pestañas
                      child: TabBarView(
                        children: [
                          Column(
                            // Contenido de la pestaña "Turnos"
                            children: [
                              ProximoTurnoPersonal(
                                nombres: nombres,
                                apellidos: apellidos,
                              ),
                              Expanded(
                                child: TurnosPersonalTable(
                                  nombres: nombres,
                                  apellidos: apellidos,
                                ),
                              ),
                            ],
                          ),
                          ConsultasPersonal(
                              servicioPersonal:
                                  servicio), // Contenido de la pestaña "Consultas"
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
