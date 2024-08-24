import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConsultasAdmin extends StatefulWidget {
  @override
  _ConsultasAdminState createState() => _ConsultasAdminState();
}

class _ConsultasAdminState extends State<ConsultasAdmin> {
  final _respuestaController = TextEditingController();

  Future<void> _addRespuesta(String docId) async {
    final respuesta = _respuestaController.text;

    if (respuesta.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('consultas')
            .doc(docId)
            .update({
          'respuesta': respuesta,
        });
        _respuestaController.clear();
      } catch (e) {
        print('Error al agregar la respuesta: $e');
      }
    } else {
      print('Entrada inválida');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consultas para Administradores')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('consultas')
              .orderBy('fecha_consulta', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final consultas = snapshot.data?.docs ?? [];

            return ListView.builder(
              itemCount: consultas.length,
              itemBuilder: (context, index) {
                final consultaData =
                    consultas[index].data() as Map<String, dynamic>;
                final nombre = consultaData['nombre'];
                final servicio = consultaData['servicio'];
                final subServicio = consultaData['subServicio'];
                final consulta = consultaData['consulta'];
                final respuesta = consultaData['respuesta'];
                final docId = consultas[index].id;

                return ListTile(
                  title: Text('Nombre: $nombre'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Servicio: $servicio'),
                      Text('Sub-Servicio: $subServicio'),
                      Text('Consulta: $consulta'),
                      if (respuesta.isNotEmpty) Text('Respuesta: $respuesta'),
                      if (respuesta.isEmpty)
                        Column(
                          children: [
                            TextField(
                              controller: _respuestaController,
                              decoration: InputDecoration(
                                  labelText: 'Escribe tu respuesta'),
                            ),
                            ElevatedButton(
                              onPressed: () => _addRespuesta(docId),
                              child: Text('Responder'),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
