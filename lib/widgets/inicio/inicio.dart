import 'package:flutter/material.dart';
import '../modal_navbar.dart';
import '../navbar.dart';


class Inicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Altura del NavBar
        child: NavBar(), // Usa el NavBar como appBar
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.red,
            height: 400, // Ajusta la altura según sea necesario
            child: Center(
              child: Text('Cuadro Rojo', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ),
          Container(
            color: Colors.green,
            height: 300, // Ajusta la altura según sea necesario
            child: Center(
              child: Text('Cuadro Verde', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ),
          Container(
            color: Colors.blue,
            height: 500, // Ajusta la altura según sea necesario
            child: Center(
              child: Text('Cuadro Azul', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ),
          Container(
            color: Colors.orange,
            height: 400, // Ajusta la altura según sea necesario
            child: Center(
              child: Text('Cuadro Naranja', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ),
        ],
      ),
      endDrawer: ModalNavBar(), // Usa el ModalNavBar
    );
  }
}
