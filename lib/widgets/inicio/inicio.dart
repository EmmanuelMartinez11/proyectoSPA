import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:proyecto_flutter/widgets/comentario_consultas/comentarios_consultas.dart';
import 'package:proyecto_flutter/widgets/inicio/carousel.dart';
import 'package:proyecto_flutter/widgets/noticias/noticias.dart';
import 'package:proyecto_flutter/widgets/servicios/servicios.dart';
import '../quienes_somos/nosotros.dart';
import '../contacto/contacto.dart';
import '../navbar.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  late InfiniteScrollController _carouselController;
  final ScrollController _scrollController = ScrollController();
  bool _showNavBar = true;

  final GlobalKey _serviciosKey = GlobalKey();
  final GlobalKey _noticiasKey = GlobalKey();
  final GlobalKey _contactoKey = GlobalKey();
  final GlobalKey _quienesSomosKey = GlobalKey();
  final GlobalKey _comunidadKey = GlobalKey(); // Nuevo GlobalKey

  @override
  void initState() {
    super.initState();
    _carouselController = InfiniteScrollController();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showNavBar) {
        setState(() {
          _showNavBar = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_showNavBar) {
        setState(() {
          _showNavBar = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _carouselController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: CarouselWidget(
                    items: const [
                      {
                        "image": "assets/images/belleza.webp",
                        "title": "Belleza",
                        "description":
                            "Realza tu belleza natural con nuestros tratamientos exclusivos."
                      },
                      {
                        "image": "assets/images/Facial.webp",
                        "title": "Tratamientos Faciales",
                        "description":
                            "Revitaliza tu piel con nuestras técnicas avanzadas de cuidado facial."
                      },
                      {
                        "image": "assets/images/corporales.webp",
                        "title": "Tratamientos Corporales",
                        "description":
                            "Cuida y tonifica tu cuerpo con nuestros tratamientos personalizados."
                      },
                      {
                        "image": "assets/images/masajes.webp",
                        "title": "Masajes",
                        "description":
                            "Relájate y desconecta con nuestros masajes terapéuticos."
                      },
                    ],
                    carouselController: _carouselController,
                    serviciosKey: _serviciosKey,
                  ),
                ),
                Container(
                  key: _quienesSomosKey,
                  child: AboutSection(),
                ),
                Container(
                  key: _serviciosKey,
                  child: ServiciosPage(),
                ),
                Container(
                  key: _noticiasKey,
                  child: NoticiasPage(),
                ),
                Container(
                  key: _comunidadKey, // Agregado aquí
                  child: ComentariosConsultas(),
                ),
                Container(
                  key: _contactoKey,
                  child: ContactSection(
                    spaLocation:
                        const LatLng(-27.450953544514192, -58.97908033769105),
                  ),
                ),
              ],
            ),
          ),
          if (_showNavBar)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _showNavBar ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: NavBar(
                    quienesSomosKey: _quienesSomosKey,
                    serviciosKey: _serviciosKey,
                    noticiasKey: _noticiasKey,
                    contactoKey: _contactoKey,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
