import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_flutter/utils/crud_turnos.dart';

class ProximoTurno extends StatelessWidget {
  final String nombres;
  final String apellidos;

  ProximoTurno({required this.nombres, required this.apellidos});

  @override
  Widget build(BuildContext context) {
    final turnoService = TurnoService();

    return FutureBuilder<Map<String, dynamic>?>(
      future: obtenerProximoTurno(turnoService, nombres, apellidos),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No tienes próximos turnos.'));
        }

        final turno = snapshot.data!;
        final fecha = (turno['fecha_turno'] as Timestamp).toDate();
        final fechaFormateada = DateFormat('dd-MM-yyyy').format(fecha);
        final horaFormateada = DateFormat('HH:mm').format(fecha);
        final servicio = '${turno['servicio']} - ${turno['especialidad']}';
        final personal = turno['personal_a_cargo'];
        final codigoSeguridad = turno['id'];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Próximo Turno',
                      style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: 8),
                  Text('Fecha: $fechaFormateada'),
                  Text('Hora: $horaFormateada'),
                  Text('Servicio: $servicio'),
                  Text('Personal a cargo: $personal'),
                  Text('Código de seguridad: $codigoSeguridad'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>?> obtenerProximoTurno(
      TurnoService turnoService, String nombres, String apellidos) async {
    try {
      // Obtiene todos los turnos del cliente
      List<Map<String, dynamic>> turnos =
          await turnoService.obtenerTurnosCliente('$nombres $apellidos');
      if (turnos.isEmpty) return null;

      // Filtra los turnos futuros
      DateTime ahora = DateTime.now();
      turnos = turnos.where((turno) {
        DateTime fechaTurno = (turno['fecha_turno'] as Timestamp).toDate();
        return fechaTurno.isAfter(ahora);
      }).toList();

      // Ordena los turnos por fecha más cercana
      turnos.sort((a, b) {
        DateTime fechaA = (a['fecha_turno'] as Timestamp).toDate();
        DateTime fechaB = (b['fecha_turno'] as Timestamp).toDate();
        return fechaA.compareTo(fechaB);
      });

      // Retorna el primer turno (el más cercano)
      return turnos.isNotEmpty ? turnos.first : null;
    } catch (e) {
      print('Error al obtener el próximo turno: $e');
      return null;
    }
  }
}
