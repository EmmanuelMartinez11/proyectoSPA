import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'nosotros.dart';
import 'carousel.dart';
import 'contacto.dart';
import '../navbar.dart'; 

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final ScrollController _scrollController = ScrollController();
  bool _showNavBar = true;

   @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_showNavBar) {
          setState(() {
            _showNavBar = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_showNavBar) {
          setState(() {
            _showNavBar = true;
          });
        }
      }
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: CarouselWidget(
                    items: const [
                      {
                        "image": "../assets/images/inicio/belleza.webp",
                        "title": "Belleza",
                        "description": "Realza tu belleza natural con nuestros tratamientos exclusivos."
                      },
                      {
                        "image": "../assets/images/inicio/facial.webp",
                        "title": "Tratamientos Faciales",
                        "description": "Revitaliza tu piel con nuestras técnicas avanzadas de cuidado facial."
                      },
                      {
                        "image": "../assets/images/inicio/corporales.webp",
                        "title": "Tratamientos Corporales",
                        "description": "Cuida y tonifica tu cuerpo con nuestros tratamientos personalizados."
                      },
                      {
                        "image": "../assets/images/inicio/masajes.webp",
                        "title": "Masajes",
                        "description": "Relájate y desconecta con nuestros masajes terapéuticos."
                      },
                    ],
                    carouselController: InfiniteScrollController(),
                  ),
                ),
                const SizedBox(height: 20),
                AboutSection(),
                const SizedBox(height: 20),
                ContactSection(
                  spaLocation: const LatLng(-27.450953544514192, -58.97908033769105),
                ),
              ],
            ),
          ),
          // NavBar en la parte superior
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedOpacity(
              opacity: _showNavBar ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.transparent, // Fondo transparente para el navbar
                child: NavBar(), 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
