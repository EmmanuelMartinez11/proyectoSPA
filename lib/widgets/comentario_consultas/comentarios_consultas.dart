import 'package:flutter/material.dart';
import 'comentarios.dart'; // Importa la página de comentarios
import 'consultas.dart'; // Importa la página de consultas

class ComentariosConsultas extends StatefulWidget {
  final Key? key;

  ComentariosConsultas({this.key}) : super(key: key);

  @override
  _ComentariosConsultasState createState() => _ComentariosConsultasState();
}

class _ComentariosConsultasState extends State<ComentariosConsultas>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Consultas'),
            Tab(text: 'Comentarios'),
          ],
        ),
        SizedBox(
          height: 600.0, // Ajusta esta altura según sea necesario
          child: TabBarView(
            controller: _tabController,
            children: [
              Consultas(), // Página de Consultas
              Comentarios(), // Página de Comentarios
            ],
          ),
        ),
      ],
    );
  }
}
