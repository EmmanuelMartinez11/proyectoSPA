import 'package:flutter/material.dart';
import 'turnos_personal.dart';
import 'proximo_turno_personal.dart';
import 'consultas_personal.dart'; // Importa el archivo de consultas personal
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalScreen extends StatelessWidget {
  final DocumentSnapshot personalDoc;

  PersonalScreen({required this.personalDoc});

  @override
  Widget build(BuildContext context) {
    // Accede a los datos del personal desde personalDoc
    String nombres = personalDoc['nombres'];
    String apellidos = personalDoc['apellidos'];
    String rolPersonal = personalDoc['rol'];

    // Define la variable servicio basada en el rolPersonal
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
      appBar: AppBar(
        title: Text('Bienvenido $nombres $apellidos'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  TabBar(
                    tabs: [
                      Tab(text: 'Turnos'),
                      Tab(text: 'Consultas'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Column(
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
                        ConsultasPersonal(servicioPersonal: servicio),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
