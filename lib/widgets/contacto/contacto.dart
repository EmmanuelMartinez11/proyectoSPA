import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  final LatLng spaLocation;
  final Key? key;

  ContactSection({
    required this.spaLocation,
    this.key,
  });

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(238, 124, 168, 119),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  bottom: -40,
                  child: Image.asset(
                    '../assets/images/inicio/background.png',
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Contáctanos',
                      style: GoogleFonts.dancingScript(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.whatsapp,
                            color: Colors.black),
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
                        const FaIcon(FontAwesomeIcons.twitter,
                            color: Colors.black),
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
                        const FaIcon(FontAwesomeIcons.instagram,
                            color: Colors.black),
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
                        const FaIcon(FontAwesomeIcons.envelope,
                            color: Colors.black),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () =>
                              _launchURL('mailto:info@spasentirsebien.com'),
                          child: const Text(
                            'info@spasentirsebien.com',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                height: 300,
                color: Colors.white,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: spaLocation,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('Spa'),
                      position: spaLocation,
                      infoWindow: const InfoWindow(
                        title: 'Spa Sentirse Bien',
                        snippet: 'Calle French 440, Resistencia, Chaco',
                      ),
                    ),
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
