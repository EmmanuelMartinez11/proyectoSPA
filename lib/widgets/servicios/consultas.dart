import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Consultas extends StatefulWidget {
  @override
  _ConsultasPageState createState() => _ConsultasPageState();
}

class _ConsultasPageState extends State<Consultas> {
  final _nameController = TextEditingController();
  final _consultaController = TextEditingController();
  String? _selectedService;
  String? _selectedSubService;

  final Map<String, List<String>> _services = {
    'Masajes': [
      'Anti-stress',
      'Descontracturantes',
      'Masajes con piedras calientes',
      'Circulatorios'
    ],
    'Belleza': [
      'Lifting de pestaña',
      'Depilación facial',
      'Belleza de manos y pies'
    ],
    'Tratamientos Faciales': [
      'Punta de Diamante: Microexfoliación',
      'Limpieza profunda + Hidratación',
      'Crio frecuencia facial'
    ],
    'Tratamientos Corporales': [
      'VelaSlim',
      'DermoHealth',
      'Criofrecuencia',
      'Ultracavitación'
    ],
    'Otro': []
  };

  Future<void> _addConsulta() async {
    final nombre = _nameController.text;
    final consultaTexto = _consultaController.text;
    final servicio = _selectedService ?? 'Otro';
    final subServicio = _selectedSubService ?? 'N/A';

    if (nombre.isNotEmpty && consultaTexto.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('consultas').add({
          'nombre': nombre,
          'consulta': consultaTexto,
          'servicio': servicio,
          'subServicio': subServicio,
          'fecha_publicacion': Timestamp.now(),
          'respuesta': '', // Inicialmente sin respuesta
          'fecha_respuesta': null, // Inicialmente sin fecha de respuesta
        });
        _nameController.clear();
        _consultaController.clear();
        setState(() {
          _selectedService = null;
          _selectedSubService = null;
        });
      } catch (e) {
        print('Error al agregar la consulta: $e');
      }
    } else {
      print('Nombre y consulta son requeridos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Formulario para agregar consulta
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Servicio'),
              value: _selectedService,
              items: _services.keys.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedService = newValue;
                  _selectedSubService = null;
                });
              },
            ),
            SizedBox(height: 16.0),
            if (_selectedService != 'Otro')
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Sub-servicio'),
                value: _selectedSubService,
                items: (_services[_selectedService] ?? []).map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedSubService = newValue;
                  });
                },
              ),
            SizedBox(height: 16.0),
            TextField(
              controller: _consultaController,
              decoration: InputDecoration(labelText: 'Consulta'),
              maxLines: 3,
            ),
            ElevatedButton(
              onPressed: _addConsulta,
              child: Text('Agregar Consulta'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('consultas')
                    .orderBy('fecha_publicacion', descending: true)
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
