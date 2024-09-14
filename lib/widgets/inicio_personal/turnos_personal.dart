import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_flutter/utils/crud_turnos.dart';
import 'package:intl/intl.dart';

class TurnosPersonalTable extends StatefulWidget {
  final String nombres;
  final String apellidos;


  TurnosPersonalTable({required this.nombres, required this.apellidos,});

  @override
  _TurnosPersonalTableState createState() => _TurnosPersonalTableState();
}

class _TurnosPersonalTableState extends State<TurnosPersonalTable> {
  final TurnoService turnoService = TurnoService();
  late DateTime _selectedDate;
  late Stream<List<Map<String, dynamic>>> _turnosStream;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _turnosStream = _obtenerTurnosPorFecha(_selectedDate);
  }

  Stream<List<Map<String, dynamic>>> _obtenerTurnosPorFecha(
      DateTime fecha) async* {
    final nombreCompleto = '${widget.nombres} ${widget.apellidos}';
    while (true) {
      final turnos = await turnoService.obtenerTurnosPorFechaYPersonal(
          fecha, nombreCompleto);
      yield turnos;
      await Future.delayed(Duration(seconds: 1));
    }
  }

  void _seleccionarFecha() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _turnosStream = _obtenerTurnosPorFecha(_selectedDate);
      });
    }
  }

  Future<void> _cancelarTurno(String turnoId) async {
    try {
      await turnoService.cancelarTurno(turnoId);
      print('Turno $turnoId eliminado correctamente.');
    } catch (e) {
      print('Error al cancelar el turno $turnoId: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Turnos del personal - ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: _seleccionarFecha,
            ),
          ],
        ),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _turnosStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final turnos = snapshot.data ?? [];

              final List<String> horas = [
                '08:00',
                '09:00',
                '10:00',
                '11:00',
                '12:00',
                '13:00',
                '14:00',
                '15:00',
                '16:00',
                '17:00',
                '18:00',
                '19:00',
                '20:00',
                '21:00',
                '22:00',
              ];

              return DataTable(
                columns: [
                  DataColumn(label: Text('Hora')),
                  DataColumn(label: Text('Servicio')),
                  DataColumn(label: Text('Cliente')),
                  DataColumn(label: Text('')),
                ],
                rows: horas.map((hora) {
                  final turno = turnos.firstWhere(
                    (t) =>
                        DateFormat('HH:mm')
                            .format((t['fecha_turno'] as Timestamp).toDate()) ==
                        hora,
                    orElse: () => {},
                  );

                  // Verifica si el turno es en el futuro
                  final esFuturo = turno.isNotEmpty
                      ? (turno['fecha_turno'] as Timestamp)
                          .toDate()
                          .isAfter(DateTime.now())
                      : false;

                  return DataRow(
                    cells: [
                      DataCell(Text(hora)),
                      DataCell(Text(turno.isNotEmpty
                          ? '${turno['servicio']} - ${turno['especialidad']}'
                          : '')),
                      DataCell(Text(turno.isNotEmpty ? turno['cliente'] : '')),
                      DataCell(
                        esFuturo
                            ? IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  final turnoId = turno['id'];
                                  print(
                                      'Intentando eliminar el turno $turnoId');
                                  await _cancelarTurno(turnoId);
                                },
                              )
                            : SizedBox
                                .shrink(), // Muestra botón si el turno es en el futuro
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
