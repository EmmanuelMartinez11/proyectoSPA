import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_flutter/utils/crud_turnos.dart';

class TurnosClienteTable extends StatefulWidget {
  final String nombres;
  final String apellidos;

  TurnosClienteTable({required this.nombres, required this.apellidos});

  @override
  _TurnosClienteTableState createState() => _TurnosClienteTableState();
}

class _TurnosClienteTableState extends State<TurnosClienteTable> {
  final TurnoService turnoService = TurnoService();
  late Stream<List<Map<String, dynamic>>> _turnosStream;

  @override
  void initState() {
    super.initState();
    _turnosStream = _obtenerTurnosPorCliente(widget.nombres, widget.apellidos);
  }

  Stream<List<Map<String, dynamic>>> _obtenerTurnosPorCliente(
      String nombres, String apellidos) async* {
    final nombreCompleto = '$nombres $apellidos';
    while (true) {
      final turnos = await turnoService.obtenerTurnosCliente(nombreCompleto);
      yield turnos;
      await Future.delayed(Duration(seconds: 1)); // Actualizar cada 10 segundos
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _turnosStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No tienes turnos registrados.'));
        }

        final turnos = snapshot.data!;

        // Ordena los turnos por fecha de mayor a menor
        turnos.sort((a, b) {
          DateTime fechaA = (a['fecha_turno'] as Timestamp).toDate();
          DateTime fechaB = (b['fecha_turno'] as Timestamp).toDate();
          return fechaB.compareTo(fechaA); // Orden descendente
        });

        return DataTable(
          columns: [
            DataColumn(label: Text('Fecha')),
            DataColumn(label: Text('Hora')),
            DataColumn(label: Text('Servicio')),
            DataColumn(label: Text('Personal')),
            DataColumn(label: Text('')),
          ],
          rows: turnos.map((data) {
            final fecha = (data['fecha_turno'] as Timestamp).toDate();
            final fechaFormateada = '${fecha.day}/${fecha.month}/${fecha.year}';
            final horaFormateada =
                '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
            final servicio = '${data['servicio']} - ${data['especialidad']}';
            final personal = data['personal_a_cargo'];
            final turnoId = data['id'];
            final ahora = DateTime.now();

            return DataRow(
              cells: [
                DataCell(Text(fechaFormateada)),
                DataCell(Text(horaFormateada)),
                DataCell(Text(servicio)),
                DataCell(Text(personal)),
                DataCell(
                  Row(
                    children: [
                      if (fecha.isAfter(
                          ahora)) // Solo muestra el ícono si el turno es en el futuro
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await turnoService.cancelarTurno(turnoId);
                          },
                        ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
