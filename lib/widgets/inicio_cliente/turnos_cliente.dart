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
      final List<Map<String, dynamic>> turnosActualizados = [];

      final ahora = DateTime.now();

      for (var turno in turnos) {
        DateTime fechaTurno = (turno['fecha_turno'] as Timestamp).toDate();
        String estado = turno['estado'] ?? "Reservado"; // Valor por defecto

        // Asegúrate de que el estado solo se modifica si no es "Pagado"
        if (estado != "Pagado") {
          final diferenciaDias = fechaTurno.difference(ahora).inDays;
          if (diferenciaDias > 2) {
            estado = "Reservado";
          } else if (diferenciaDias <= 2) {
            estado = "Caducado";
          }

          // Actualizar el estado en Firebase si ha cambiado
          if (estado != turno['estado']) {
            await turnoService.actualizarTurno(turno['id'], {'estado': estado});
          }
        }

        // Agregar turno actualizado
        turnosActualizados.add({
          ...turno,
          'estado': estado,
        });
      }

      yield turnosActualizados;
      await Future.delayed(
          const Duration(seconds: 10)); // Actualizar cada 10 segundos
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

        // Ordena los turnos por fecha de mayor a menor
        turnos.sort((a, b) {
          DateTime fechaA = (a['fecha_turno'] as Timestamp).toDate();
          DateTime fechaB = (b['fecha_turno'] as Timestamp).toDate();
          return fechaB.compareTo(fechaA); // Orden descendente
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
            final precio = (data['precio'] != null)
                ? data['precio'].toString()
                : "No disponible"; // Maneja el caso nulo
            final estado = data['estado'];
            final turnoId = data['id'];

            return DataRow(
              cells: [
                DataCell(Text(fechaFormateada)),
                DataCell(Text(horaFormateada)),
                DataCell(Text(servicio)),
                DataCell(Text(personal)),
                DataCell(Text(precio)), // Usar el valor asegurado
                DataCell(
                    Text(estado ?? "No disponible")), // Manejamos el caso nulo
                DataCell(
                  Row(
                    children: [
                      if (estado == "Reservado")
                        IconButton(
                          icon: const Icon(Icons.attach_money),
                          onPressed: () {
                            _mostrarDialogoConfirmacion(
                                turnoId); // Llama al diálogo
                          },
                        ),
                      // Solo mostrar el ícono de eliminar si el estado no es "Pagado" o "Caducado"
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
