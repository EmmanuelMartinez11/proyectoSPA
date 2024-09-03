import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comentarios extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<Comentarios> {
  final _nameController = TextEditingController();
  final _ratingController = TextEditingController();
  final _commentController = TextEditingController();

  Future<void> _addComment() async {
    final nombre = _nameController.text;
    final calificacion = int.tryParse(_ratingController.text) ?? 0;
    final comentario = _commentController.text;

    if (nombre.isNotEmpty &&
        calificacion >= 1 &&
        calificacion <= 5 &&
        comentario.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('comentarios').add({
          'nombre': nombre,
          'calificacion': calificacion,
          'comentario': comentario,
          'fecha_publicacion': Timestamp.now(),
        });
        // Clear text fields after submission
        _nameController.clear();
        _ratingController.clear();
        _commentController.clear();
      } catch (e) {
        print('Error al agregar el comentario: $e');
      }
    } else {
      print('Entrada inválida');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _ratingController,
              decoration: InputDecoration(labelText: 'Calificación (1-5)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Comentario'),
            ),
            ElevatedButton(
              onPressed: _addComment,
              child: Text('Agregar Comentario'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('comentarios')
                    .orderBy('fecha_publicacion', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final comentarios = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    itemCount: comentarios.length,
                    itemBuilder: (context, index) {
                      final comentarioData =
                          comentarios[index].data() as Map<String, dynamic>;
                      final nombre = comentarioData['nombre'];
                      final calificacion = comentarioData['calificacion'];
                      final comentario = comentarioData['comentario'];

                      return ListTile(
                        title: Text(nombre),
                        subtitle: Text(
                            'Calificación: $calificacion\nComentario: $comentario'),
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
