import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final List<Map<String, String>> navLinks = [
    {"label": "Inicio", "route": "/inicio"},
    {"label": "Servicios", "route": "/servicios"},
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth <= 600;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: 80, // Adjust height as needed
          decoration: const BoxDecoration(
            color: Colors.transparent, // Set background color to transparent
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Logo
              Image.asset(
                '../assets/images/logo_spa.png', // Update path if needed
                height: 60, // Adjust height as needed
              ),
              // Links de navegación
              Row(
                children: navLinks.map((item) {
                  return Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, item["route"]!);
                        },
                        child: Text(
                          item["label"]!,
                          style: const TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.black, // Adjust text color for visibility
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              // Botón de Ingresar
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/ingresar");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Ingresar',
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
