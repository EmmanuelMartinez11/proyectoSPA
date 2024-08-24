import 'package:flutter/material.dart';
import 'comentarios.dart'; // Importa la página de comentarios
import 'consultas.dart'; // Importa la página de consultas
import '../modal_navbar.dart';
import '../navbar.dart';

class Servicios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80), // Altura del NavBar
          child: NavBar(), // Usa el NavBar como appBar
        ),
        body: Column(
          children: <Widget>[
            TabBar(
              tabs: [
                Tab(text: 'Consultas'),
                Tab(text: 'Comentarios'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Consultas(), // Página de Consultas
                  Comentarios(), // Página de Comentarios
                ],
              ),
            ),
          ],
        ),
        endDrawer: ModalNavBar(), // Usa el ModalNavBar
      ),
    );
  }
}
