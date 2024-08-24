import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConsultasPersonal extends StatefulWidget {
  final String servicioPersonal;

  ConsultasPersonal({required this.servicioPersonal});

  @override
  _ConsultasPersonalState createState() => _ConsultasPersonalState();
}

class _ConsultasPersonalState extends State<ConsultasPersonal> {
  final _respuestaController =
      TextEditingController(); // Controlador para la respuesta

  Future<void> _addResponse(String docId) async {
    final respuestaTexto = _respuestaController.text;

    if (respuestaTexto.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('consultas')
            .doc(docId)
            .update({
          'respuesta': respuestaTexto,
          'fecha_respuesta': Timestamp.now(),
        });
        _respuestaController.clear();
      } catch (e) {
        print('Error al agregar la respuesta: $e');
      }
    } else {
      print('La respuesta no puede estar vacía');
    }
  }

  Future<void> _deleteConsulta(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('consultas')
          .doc(docId)
          .delete();
    } catch (e) {
      print('Error al eliminar la consulta: $e');
    }
  }

  Stream<List<QueryDocumentSnapshot>> _fetchConsultas() {
    final consultaServicioPersonal = FirebaseFirestore.instance
        .collection('consultas')
        .where('servicio', isEqualTo: widget.servicioPersonal)
        .snapshots();

    final consultaOtro = FirebaseFirestore.instance
        .collection('consultas')
        .where('servicio', isEqualTo: 'Otro')
        .snapshots();

    return FirebaseFirestore.instance
        .collection('consultas')
        .snapshots()
        .map((snapshot) {
      final consultas = snapshot.docs
          .where((doc) =>
              doc['servicio'] == widget.servicioPersonal ||
              doc['servicio'] == 'Otro')
          .toList();

      // Ordenar consultas por fecha_publicacion de la más reciente a la más antigua
      consultas.sort((a, b) {
        final fechaA = a['fecha_publicacion'] as Timestamp;
        final fechaB = b['fecha_publicacion'] as Timestamp;
        return fechaB.compareTo(fechaA); // Orden descendente
      });

      return consultas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<QueryDocumentSnapshot>>(
                stream: _fetchConsultas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final consultas = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: consultas.length,
                    itemBuilder: (context, index) {
                      final consultaData =
                          consultas[index].data() as Map<String, dynamic>;
                      final docId = consultas[index].id;
                      final nombre = consultaData['nombre'];
                      final servicio = consultaData['servicio'];
                      final subServicio = consultaData['subServicio'];
                      final consultaTexto = consultaData['consulta'];
                      final fecha =
                          consultaData['fecha_publicacion'] as Timestamp;
                      final horaConsulta = fecha.toDate().toLocal().toString();
                      final respuesta = consultaData['respuesta'];
                      final fechaRespuesta =
                          consultaData['fecha_respuesta'] as Timestamp?;

                      return ListTile(
                        title: Text(nombre),
                        subtitle: Text(
                          'Hora de la consulta: $horaConsulta\n'
                          'Servicio: $servicio\n'
                          'Sub-servicio: $subServicio\n'
                          'Consulta: $consultaTexto\n'
                          'Respuesta: ${respuesta ?? "Sin respuesta"}\n'
                          'Fecha de respuesta: ${fechaRespuesta != null ? fechaRespuesta.toDate().toLocal().toString() : "No respondida"}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Mostrar campo para agregar respuesta
                                _respuestaController.clear();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Responder Consulta'),
                                      content: TextField(
                                        controller: _respuestaController,
                                        decoration: InputDecoration(
                                            labelText: 'Respuesta'),
                                        maxLines: 3,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await _addResponse(docId);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Enviar Respuesta'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Confirmar eliminación
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Eliminar Consulta'),
                                      content: Text(
                                          '¿Estás seguro de que quieres eliminar esta consulta?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await _deleteConsulta(docId);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Eliminar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
