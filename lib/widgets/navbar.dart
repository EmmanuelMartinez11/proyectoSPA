import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final List<Map<String, String>> navLinks = [
    {"label": "Inicio", "route": "/inicio"},
    {"label": "Servicios", "route": "/servicios"},
    {"label": "Ingresar", "route": "/ingresar"}
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth <= 400;

        if (isSmallScreen) {
          // Para pantallas pequeñas, muestra el Drawer
          return AppBar(
            title: Text('Logo'),
            backgroundColor: Colors.cyan,
            actions: [
              IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Abre el endDrawer al hacer clic
                },
              ),
            ],
          );
        } else {
          // Para pantallas grandes, muestra el NavBar
          return Container(
            color: Colors.cyan, // Color celeste
            height: 80, // Altura del navbar
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Logo',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: navLinks.map((item) {
                      return Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click, // Cambia el cursor a una manito
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, item["route"]!); // Navega a la ruta
                            },
                            child: Text(
                              item["label"]!,
                              style: TextStyle(fontFamily: "Montserrat-Bold", color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
