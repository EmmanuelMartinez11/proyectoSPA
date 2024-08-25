import 'package:flutter/material.dart';
import 'package:proyecto_flutter/utils/crud_clientes.dart';

class NavBar extends StatelessWidget {
  final List<Map<String, String>> navLinks = [
    {"label": "Inicio", "route": "/inicio"},
    {"label": "Servicios", "route": "/servicios"},
  ];

  @override
  Widget build(BuildContext context) {
    String userType = GlobalUserType.getUserType();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            '../assets/images/logo_spa.png',
            height: 60,
          ),
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
                        color: Colors.black,
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
          Text(
            userType,
            style: const TextStyle(
              fontFamily: "Montserrat",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/ingresar");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
  }
}
