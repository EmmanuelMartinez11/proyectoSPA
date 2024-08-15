import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:infinite_carousel/infinite_carousel.dart';
import '../navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../inicio/InfoBox.dart';
import 'package:url_launcher/url_launcher.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  List<Map<String, String>> carouselItems = [
    {
      "image": "../assets/images/inicio/belleza.jpg",
      "title": "Belleza",
      "description": "Realza tu belleza natural con nuestros tratamientos exclusivos."
    },
    {
      "image": "../assets/images/inicio/facial.jpg",
      "title": "Tratamientos Faciales",
      "description": "Revitaliza tu piel con nuestras técnicas avanzadas de cuidado facial."
    },
    {
      "image": "../assets/images/inicio/corporales.jpg",
      "title": "Tratamientos Corporales",
      "description": "Cuida y tonifica tu cuerpo con nuestros tratamientos personalizados."
    },
    {
      "image": "../assets/images/inicio/masajes.jpg",
      "title": "Masajes",
      "description": "Relájate y desconecta con nuestros masajes terapéuticos."
    },
  ];

  final LatLng _spaLocation = const LatLng(-27.450953544514192, -58.97908033769105); // Coordenadas del spa
  final InfiniteScrollController _carouselController = InfiniteScrollController();
  final ScrollController _scrollController = ScrollController();
  bool _showNavBar = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Configure automatic scrolling
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _carouselController.nextItem(); // Move to the next item
    });

    // Add scroll listener
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
    _timer?.cancel(); // Stop the timer
    _carouselController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // CustomScrollView to allow scrolling of the content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Carrusel de imágenes
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height, // Ajusta la altura para ocupar toda la pantalla
                  width: MediaQuery.of(context).size.width,
                  child: InfiniteCarousel.builder(
                    controller: _carouselController,
                    itemCount: carouselItems.length,
                    itemExtent: MediaQuery.of(context).size.width, // Ajusta el itemExtent para que solo se muestre una imagen por vez
                    center: true,
                    anchor: 0.0,
                    velocityFactor: 0.5,
                    itemBuilder: (context, itemIndex, realIndex) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          // Imagen de fondo
                          Image.asset(
                            carouselItems[itemIndex]["image"]!,
                            fit: BoxFit.cover,
                          ),
                          // Superposición de título y descripción centrada
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  carouselItems[itemIndex]["title"]!,
                                  style: GoogleFonts.notoSerif(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      const Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  carouselItems[itemIndex]["description"]!,
                                  style: GoogleFonts.notoSerif(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      const Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                HoverButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/servicios");
                                  },
                                  text: 'Conoce más',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              // Sección "Quiénes somos"
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(166, 244, 143, 177),
                    image: DecorationImage(
                      image: AssetImage('../assets/images/inicio/chill.png'), // Imagen de fondo
                      fit: BoxFit.none,
                      alignment: Alignment.bottomLeft, // Alineación de la imagen de fondo
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 200), // Aumentar margen lateral
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'SPA SENTIRSE BIEN',
                            style: GoogleFonts.notoSerif(
                              fontSize: 20,
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Bienvenido a este hogar de Tranquilidad, Relajación y Descanso.',
                            style: GoogleFonts.dancingScript(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Todo el mundo busca lugares donde relajarse y recargar energía. En nuestro centro de bienestar nos damos cita al silencio, la energía, la belleza y la vitalidad. Los tratamientos que ofrecemos refrescarán tanto tu cuerpo como tu alma.\nEstaremos encantados de recibirte',
                            style: GoogleFonts.notoSerif(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InfoBox(
                                imagePath: '../assets/images/inicio/spa1.jpg',
                                title: '¿Qué deseamos?',
                                content: 'Crear experiencias únicas y personalizadas, donde cada detalle está diseñado para que nuestros clientes logren desconectarse de la rutina y se sumerjan en un oasis de calma y relajación, en completa armonía con la naturaleza.',
                              ),
                              const SizedBox(width: 20),
                              InfoBox(
                                imagePath: '../assets/images/inicio/spa2.jpg', 
                                title: '¿Qué buscamos?', 
                                content: 'Ser los referentes en bienestar, conocidos por innovar en tratamientos que no solo cuidan el cuerpo, sino que también revitalizan el espíritu, ofreciendo un refugio perfecto para la mente y el cuerpo.',
                              ),
                              const SizedBox(width: 20),
                              InfoBox(
                                imagePath: '../assets/images/inicio/spa3.jpg', 
                                title: '¿Cómo lo haremos?', 
                                content: 'Nos comprometemos a mantener los más altos estándares en cada servicio, asegurando que cada cliente reciba atención personalizada, utilizando productos de la mejor calidad y técnicas avanzadas en cada tratamiento.',
                              ),
                            ],
                          ),
                        ],
                      ),                     
                    ],
                  ),
                ),
              ),
              // Sección de contacto y mapa
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(238, 124, 168, 119),
                    image: DecorationImage(
                      image: AssetImage('../assets/images/inicio/background.png'),
                      fit: BoxFit.none,
                      alignment: Alignment.bottomLeft,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sección de redes sociales y contacto
                      Expanded(
                        flex: 1, // Menor espacio asignado
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Contáctanos',
                              style: GoogleFonts.dancingScript(
                                fontSize: 40, // Ajusta el tamaño según sea necesario
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.black),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _launchURL('https://web.whatsapp.com/'),
                                  child: const Text(
                                  '+54 8888-888888',
                                  style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.twitter, color: Colors.black),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _launchURL('https://x.com/'),
                                  child: const Text(
                                  '@spa_sentirsebien',
                                  style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.instagram, color: Colors.black),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _launchURL('https://www.instagram.com/'),
                                  child: const Text(
                                  '@spa_sentirsebien',
                                  style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.envelope, color: Colors.black),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _launchURL('https://mail.google.com/'),
                                  child: const Text(
                                  'spa_sentirsebien@gmail.com',
                                  style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Mapa
                      Expanded(
                        flex: 2, // Más espacio asignado
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4, // Ajusta el tamaño según sea necesario
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _spaLocation,
                              zoom: 17.0,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('Spa'),
                                position: _spaLocation,
                                infoWindow: const InfoWindow(
                                  title: 'Spa Sentirse Bien',
                                  snippet: 'Calle French 440, Resistencia, Chaco',
                                ),
                              ),
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
                child: NavBar(), // Asegúrate de que NavBar tenga fondo transparente
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
