import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/inicio_cliente/inicio_cliente.dart'; // Asegúrate de que esto apunte correctamente a tu pantalla de cliente

class NavBar extends StatefulWidget {
  final GlobalKey? quienesSomosKey;
  final GlobalKey? noticiasKey;
  final GlobalKey? serviciosKey;
  final GlobalKey? contactoKey;
  NavBar({
    this.quienesSomosKey,
    this.noticiasKey,
    this.serviciosKey,
    this.contactoKey,
  });

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final List<Map<String, String>> navLinks = [
    {"label": "Inicio", "route": "/inicio"},
    {"label": "Quiénes Somos", "route": "quienes-somos"},
    {"label": "Servicios", "route": "servicios"},
    {"label": "Noticias", "route": "noticias"},
    {"label": "Contactos", "route": "contacto"},
  ];

  Future<DocumentSnapshot> _getUserDoc(String uid) async {
    DocumentSnapshot clienteDoc =
        await FirebaseFirestore.instance.collection('clientes').doc(uid).get();

    if (clienteDoc.exists) {
      return clienteDoc;
    }

    DocumentSnapshot personalDoc =
        await FirebaseFirestore.instance.collection('personal').doc(uid).get();

    if (personalDoc.exists) {
      return personalDoc;
    }

    throw Exception('Usuario no encontrado');
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/inicio', (route) => false);
  }

  void _scrollToSection(String route) {
    final BuildContext? targetContext;

    switch (route) {
      case 'quienes-somos':
        targetContext = widget.quienesSomosKey?.currentContext;
        break;
      case 'noticias':
        targetContext = widget.noticiasKey?.currentContext;
        break;
      case 'servicios':
        targetContext = widget.serviciosKey?.currentContext;
        break;
      case 'contacto':
        targetContext = widget.contactoKey?.currentContext;
        break;
      default:
        Navigator.pushNamed(context, route);
        return;
    }

    if (targetContext != null) {
      Scrollable.ensureVisible(targetContext,
          duration: Duration(milliseconds: 300));
    } else {
      Navigator.pushNamed(context, route);
    }
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
                    padding: const EdgeInsets.only(left: 20),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: () => _scrollToSection(item["route"]!),
                        child: Text(
                          item["label"]!,
                          style: _navBarTextStyle(),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (user != null)
                FutureBuilder<DocumentSnapshot>(
                  future: _getUserDoc(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('Error al cargar datos');
                    } else {
                      String userName = snapshot.data?['nombres'] ?? 'Usuario';
                      return PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'logout') {
                            _signOut();
                          } else if (value == 'profile') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClienteScreen(
                                  clienteDoc: snapshot.data!,
                                ),
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'profile',
                            child: ListTile(
                              title: Text(userName),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClienteScreen(
                                      clienteDoc: snapshot.data!,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: ListTile(
                              title: Text('Cerrar Sesión'),
                              leading: Icon(Icons.exit_to_app),
                            ),
                          ),
                        ],
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              Text(
                                userName,
                                style: _navBarTextStyle(),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.arrow_drop_down,
                                  color: Colors.white),
                            ],
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Ingresar',
                    style: _navBarTextStyle(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

TextStyle _navBarTextStyle() {
  return GoogleFonts.cardo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    color: Colors.white,
    shadows: [
      const Shadow(
        blurRadius: 2.0,
        color: Colors.black,
        offset: Offset(2.0, 2.0),
      ),
    ],
  );
}
