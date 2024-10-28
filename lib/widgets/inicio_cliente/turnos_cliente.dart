import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_flutter/utils/crud_turnos.dart';
import 'package:printing/printing.dart'; // Paquete para manejar PDF e impresión
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
      final List<Map<String, dynamic>> turnosActualizados = [];

      final ahora = DateTime.now();

      for (var turno in turnos) {
        DateTime fechaTurno = (turno['fecha_turno'] as Timestamp).toDate();
        String estado = turno['estado'] ?? "Reservado"; // Valor por defecto

        if (estado != "Pagado") {
          final diferenciaDias = fechaTurno.difference(ahora).inDays;
          if (diferenciaDias > 2) {
            estado = "Reservado";
          } else if (diferenciaDias <= 2) {
            estado = "Caducado";
          }

          if (estado != turno['estado']) {
            await turnoService.actualizarTurno(turno['id'], {'estado': estado});
          }
        }

        turnosActualizados.add({
          ...turno,
          'estado': estado,
        });
      }

      yield turnosActualizados;
      await Future.delayed(const Duration(seconds: 10));
    }
  }
    // Método para mostrar el diálogo de confirmación
  Future<void> _mostrarDialogoConfirmacion(String turnoId) async {
    String? tipoPago; // Variable para almacenar el tipo de pago

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe hacer una selección
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar compra'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('¿Estás seguro de que deseas confirmar la compra?'),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: tipoPago,
                hint: const Text('Seleccionar método de pago'),
                items: <String>['Débito', 'Crédito', 'Transferencia']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    tipoPago = newValue; // Actualizar tipo de pago
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () async {
                if (tipoPago != null) {
                  // Actualiza el estado a "Pagado" y tipo de pago en Firebase
                  await turnoService.actualizarTurno(turnoId, {
                    'estado': 'Pagado',
                    'tipo_pago': tipoPago, // Actualizar tipo de pago
                  });
                } else {
                  // Manejar el caso donde no se seleccionó un método de pago
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Selecciona un método de pago')),
                  );
                  return;
                }
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
            ),
          ],
        );
      },
    );
  }
Future<void> _generarComprobantePDF(Map<String, dynamic> turno) async {
  final pdf = pw.Document();

  // Cargar el logo de los assets
  final ByteData bytes = await rootBundle.load('images/logo_spa.png'); // Cambia la ruta si es necesario
  final Uint8List logoBytes = bytes.buffer.asUint8List(); // Convertirlo a Uint8List
  final comprobanteNumero = Random().nextInt(10000); // Generar un número aleatorio para el comprobante

  // Calcular el total, si es necesario
  final double total = turno['precio']; // Ajusta esto según cómo necesites calcular el total

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Encabezado con el logo, nombre del lugar y número de comprobante
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(pw.MemoryImage(logoBytes), width: 50, height: 50), // Usar el logo cargado
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('SPA Sentirse Bien', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)), // Cambia esto por el nombre real
                    pw.Text('Comprobante N°: $comprobanteNumero', style: pw.TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Comprobante de Pago',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Cliente: ${widget.nombres} ${widget.apellidos}'),
            pw.Text('Servicio: ${turno['servicio']} - ${turno['especialidad']}'),
            pw.Text('Personal: ${turno['personal_a_cargo']}'),
            pw.Text('Fecha del Turno: ${(turno['fecha_turno'] as Timestamp).toDate()}'),
            pw.Text('Precio: ${turno['precio']}'),
            pw.Text('Estado: ${turno['estado']}'),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              data: <List<String>>[
                <String>['Servicio', 'Especialidad', 'Personal', 'Fecha', 'Precio'],
                [
                  turno['servicio'] as String,
                  turno['especialidad'] as String,
                  turno['personal_a_cargo'] as String,
                  '${(turno['fecha_turno'] as Timestamp).toDate().day}/${(turno['fecha_turno'] as Timestamp).toDate().month}/${(turno['fecha_turno'] as Timestamp).toDate().year}',
                  '${turno['precio']}',
                ],
                <String>['Total', '', '', '', '$total'],
              ],
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _turnosStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tienes turnos registrados.'));
        }

        final turnos = snapshot.data!;

        turnos.sort((a, b) {
          DateTime fechaA = (a['fecha_turno'] as Timestamp).toDate();
          DateTime fechaB = (b['fecha_turno'] as Timestamp).toDate();
          return fechaB.compareTo(fechaA);
        });

        return DataTable(
          columns: const [
            DataColumn(label: Text('Fecha')),
            DataColumn(label: Text('Hora')),
            DataColumn(label: Text('Servicio')),
            DataColumn(label: Text('Personal')),
            DataColumn(label: Text('Precio')),
            DataColumn(label: Text('Estado')),
            DataColumn(label: Text('')),
          ],
          rows: turnos.map((data) {
            final fecha = (data['fecha_turno'] as Timestamp).toDate();
            final fechaFormateada = '${fecha.day}/${fecha.month}/${fecha.year}';
            final horaFormateada =
                '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
            final servicio = '${data['servicio']} - ${data['especialidad']}';
            final personal = data['personal_a_cargo'];
            final precio = data['precio']?.toString() ?? "No disponible";
            final estado = data['estado'];
            final turnoId = data['id'];

            return DataRow(
              cells: [
                DataCell(Text(fechaFormateada)),
                DataCell(Text(horaFormateada)),
                DataCell(Text(servicio)),
                DataCell(Text(personal)),
                DataCell(Text(precio)),
                DataCell(Text(estado ?? "No disponible")),
                DataCell(
                  Row(
                    children: [
                      if (estado == "Reservado")
                        IconButton(
                          icon: const Icon(Icons.attach_money),
                          onPressed: () {
                            _mostrarDialogoConfirmacion(turnoId);
                          },
                        ),
                      if (estado == "Pagado")
                        IconButton(
                          icon: const Icon(Icons.receipt),
                          onPressed: () {
                            _generarComprobantePDF(data);
                          },
                        ),
                      if (estado != "Pagado" && estado != "Caducado")
                        IconButton(
                          icon: const Icon(Icons.delete),
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
