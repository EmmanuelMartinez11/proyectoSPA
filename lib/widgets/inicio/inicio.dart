import 'package:flutter/material.dart';
import 'dart:async';
import 'package:infinite_carousel/infinite_carousel.dart';
import '../navbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  List<String> images = [
    "../assets/images/inicio/drenaje_linfatico.jpg",
    "../assets/images/inicio/facial.jpg",
    "../assets/images/inicio/masajes.jpg",
    "../assets/images/inicio/podoestetica.jpg",
    "../assets/images/inicio/ventosas.jpg",
    "../assets/images/inicio/depilacion_laser.png",
  ];

  final LatLng _spaLocation = const LatLng(-27.450953544514192, -58.97908033769105); // Coordenadas del spa


  final InfiniteScrollController _carouselController =
      InfiniteScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Configurar el desplazamiento automático
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _carouselController.nextItem(); // Mueve al siguiente elemento
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Detiene el temporizador cuando la pantalla se destruye
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Altura del NavBar
        child: NavBar(), // Usa el NavBar como appBar
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                '../assets/images/inicio/background.jpg'), // Imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 147, 181)
                                .withOpacity(0.9),
                            border: Border.all(color: Colors.black),
                          ),
                          height: 400,
                          child: InfiniteCarousel.builder(
                            controller: _carouselController,
                            itemCount: images.length,
                            itemExtent: 400,
                            center: true,
                            anchor: 0.0,
                            velocityFactor: 0.5,
                            itemBuilder: (context, itemIndex, realIndex) {
                              return Container(
                                margin: const EdgeInsets.all(10),
                                child: Image.asset(
                                  images[itemIndex],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 147, 181)
                                .withOpacity(0.9),
                            border: Border.all(color: Colors.black),
                          ),
                          height: 400,
                          child: const Center(
                            child: Text(
                              'Sumérgete en el bienestar',
                              style: TextStyle(fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 147, 181)
                                .withOpacity(0.9),
                            border: Border.all(color: Colors.black),
                          ),
                          height: 150,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Misión\n Crear experiencias únicas y personalizadas, donde cada detalle está diseñado para que nuestros clientes logren desconectarse de la rutina y se sumerjan en un oasis de calma y relajación, en completa armonía con la naturaleza.',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 147, 181)
                                .withOpacity(0.9),
                            border: Border.all(color: Colors.black),
                          ),
                          height: 150,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Visión\n Ser el referente en bienestar, conocido por innovar en tratamientos que no solo cuidan el cuerpo, sino que también revitalizan el espíritu, ofreciendo un refugio perfecto para la mente y el cuerpo.',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 147, 181)
                                .withOpacity(0.9),
                            border: Border.all(color: Colors.black),
                          ),
                          height: 150,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Calidad\n Nos comprometemos a mantener los más altos estándares en cada servicio, asegurando que cada cliente reciba atención personalizada, utilizando productos de la mejor calidad y técnicas avanzadas en cada tratamiento.',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 216, 176, 190)
                                .withOpacity(0.9),
                            border: Border.all(color: Colors.black),
                          ),
                          height: 250,
                          child: const Padding(
                            padding: EdgeInsets.all(16.0), 
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white,),
                                    SizedBox(width: 8),
                                    Text(
                                      '+54 3716-616131',
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    FaIcon(FontAwesomeIcons.xTwitter, color: Colors.white,),
                                    SizedBox(width: 8),
                                    Text(
                                      '@spa_sentirsebien',
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    FaIcon(FontAwesomeIcons.instagram, color: Colors.white,),
                                    SizedBox(width: 8),
                                    Text(
                                      'spa_sentirsebien',
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    FaIcon(FontAwesomeIcons.envelope, color: Colors.white,),
                                    SizedBox(width: 8),
                                    Text(
                                      'spa_sentirsebien@gmail.com',
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    FaIcon(FontAwesomeIcons.locationDot, color: Colors.white,),
                                    SizedBox(width: 8),
                                    Text(
                                      'Calle French 440, Resistencia, Chaco',
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 216, 176, 190),
                            border: Border.all(color: Colors.black),
                          ),
                          height: 250,
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
                                  snippet: 'Calle French 440, Resistencia, Chaco'
                                )
                              )
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
