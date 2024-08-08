import 'package:flutter/material.dart';

class ModalNavBar extends StatelessWidget {
  final List<String> navLinks = ["Inicio", "Servicios", "Ingresar"];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.cyan,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el drawer
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...navLinks.map((text) {
                  return ListTile(
                    title: Text(text, style: TextStyle(fontSize: 16)),
                    onTap: () {
                      Navigator.of(context).pop(); // Cierra el drawer
                      Navigator.pushNamed(context, '/${text.toLowerCase()}'); // Navega a la ruta correspondiente
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
