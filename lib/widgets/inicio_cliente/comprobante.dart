import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:proyecto_flutter/utils/crud_turnos.dart';
import 'dart:math'; // Importar para generar números aleatorios

class GenerarComprobanteScreen extends StatefulWidget {
  final String nombres;
  final String apellidos;

  GenerarComprobanteScreen({required this.nombres, required this.apellidos});

  @override
  _GenerarComprobanteScreenState createState() => _GenerarComprobanteScreenState();
}

class _GenerarComprobanteScreenState extends State<GenerarComprobanteScreen> {
  final TurnoService turnoService = TurnoService();
  List<Map<String, dynamic>> turnosDisponibles = [];
  DateTime? fechaInferior;
  DateTime? fechaSuperior;
  List<Map<String, dynamic>> serviciosSeleccionados = [];

  @override
  void initState() {
    super.initState();
    _obtenerTurnos();
  }

  Future<void> _obtenerTurnos() async {
    final nombreCompleto = '${widget.nombres} ${widget.apellidos}';
    final turnos = await turnoService.obtenerTurnosCliente(nombreCompleto);

    setState(() {
      turnosDisponibles = turnos.map((turno) {
        DateTime fechaTurno = (turno['fecha_turno'] as Timestamp).toDate();
        return {
          'fecha': fechaTurno,
          'estado': turno['estado'],
          'servicio': turno['servicio'],
          'especialidad': turno['especialidad'],
          'personal': turno['personal_a_cargo'],
          'precio': 100.0,
        };
      }).toList();
    });
  }

  void _filtrarServicios() {
    if (fechaInferior != null && fechaSuperior != null) {
      setState(() {
        serviciosSeleccionados = turnosDisponibles.where((turno) {
          DateTime fechaTurnoSinHora = DateTime(turno['fecha'].year, turno['fecha'].month, turno['fecha'].day);
          return fechaTurnoSinHora.isAfter(fechaInferior!.subtract(Duration(days: 1))) && 
                 fechaTurnoSinHora.isBefore(fechaSuperior!.add(Duration(days: 1)));
        }).toList();
      });
    }
  }

  Future<Uint8List> _generarComprobantePDF() async {
  final pdf = pw.Document();
  final comprobanteNumero = Random().nextInt(10000); // Generar un número aleatorio para el comprobante

  // Cargar el logo de los assets
  final ByteData bytes = await rootBundle.load('images/logo_spa.png'); // Cargar el logo
  final Uint8List logoBytes = bytes.buffer.asUint8List(); // Convertirlo a Uint8List

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        final total = serviciosSeleccionados.fold<double>(
          0,
          (sum, turno) => sum + 100,
        );

        return pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
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
              'Comprobante de Servicios',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Cliente: ${widget.nombres} ${widget.apellidos}'),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              context: context,
              data: <List<String>>[
                <String>['Servicio', 'Especialidad', 'Personal', 'Fecha', 'Precio'],
                ...serviciosSeleccionados.map((turno) {
                  final fechaFormateada = '${turno['fecha'].day}/${turno['fecha'].month}/${turno['fecha'].year}';
                  return [
                    turno['servicio'] as String,
                    turno['especialidad'] as String,
                    turno['personal'] as String,
                    fechaFormateada,
                    '100',
                  ];
                }).toList(),
                <String>['Total', '', '', total.toString()],
              ],
            ),
          ],
        );
      },
    ),
  );

  final pdfBytes = await pdf.save();
  return Uint8List.fromList(pdfBytes);
}


  void _onGenerarComprobante() async {
    if (serviciosSeleccionados.isNotEmpty) {
      final pdfBytes = await _generarComprobantePDF();
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generar Comprobante')),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  child: Text(fechaInferior == null ? 'Selecciona fecha inferior' : fechaInferior.toString()),
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: fechaInferior ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        fechaInferior = selectedDate;
                      });
                      _filtrarServicios();
                    }
                  },
                ),
              ),
              Expanded(
                child: TextButton(
                  child: Text(fechaSuperior == null ? 'Selecciona fecha superior' : fechaSuperior.toString()),
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: fechaSuperior ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        fechaSuperior = selectedDate;
                      });
                      _filtrarServicios();
                    }
                  },
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: serviciosSeleccionados.isNotEmpty ? _onGenerarComprobante : null,
            child: Text('Generar Comprobante'),
          ),
        ],
      ),
    );
  }
}
