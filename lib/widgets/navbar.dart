import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/inicio_cliente/inicio_cliente.dart'; 

class NavBar extends StatelessWidget {
  final List<Map<String, String>> navLinks = [
    {"label": "Inicio", "route": "/inicio"},
    {"label": "Servicios", "route": "/servicios"},
  ];

  // Define el estilo común para el botón y el nombre del usuario
  TextStyle _navBarTextStyle() {
    return const TextStyle(
      fontFamily: "Montserrat",
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
      color: Colors.white,
    );
  }

  // Define el estilo común para el botón y el nombre del usuario
  ButtonStyle _navBarButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.pinkAccent,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Future<String> _getUserName(String uid) async {
    // Buscar en la colección de clientes
    DocumentSnapshot clienteDoc = await FirebaseFirestore.instance
        .collection('clientes')
        .doc(uid)
        .get();

    if (clienteDoc.exists) {
      String nombres = clienteDoc['nombres'];
      String apellidos = clienteDoc['apellidos'];
      return '$nombres $apellidos';
    }

    // Buscar en la colección de personal
    DocumentSnapshot personalDoc = await FirebaseFirestore.instance
        .collection('personal')
        .doc(uid)
        .get();

    if (personalDoc.exists) {
      String nombres = personalDoc['nombres'];
      String apellidos = personalDoc['apellidos'];
      return '$nombres $apellidos';
    }

    return 'Usuario';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

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
                          style: _navBarTextStyle(),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (user != null) // Verifica si el usuario está autenticado
                FutureBuilder<String>(
                  future: _getUserName(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error al cargar nombre');
                    } else {
                      String userName = snapshot.data ?? 'Usuario';
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClienteScreen(
                                nombres: userName.split(' ')[0],
                                apellidos: userName.split(' ').length > 1 ? userName.split(' ')[1] : '',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Text(
                            userName, // Muestra el nombre del usuario
                            style: _navBarTextStyle(),
                          ),
                        ),
                      );
                    }
                  },
                )
              else
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/ingresar");
                  },
                  style: _navBarButtonStyle(),
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
