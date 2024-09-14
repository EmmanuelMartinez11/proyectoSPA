import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'InfoBox.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromARGB(166, 244, 143, 177),
        image: DecorationImage(
          image: AssetImage('../assets/images/inicio/chill.png'),
          fit: BoxFit.none,
          alignment: Alignment.bottomLeft,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'SPA SENTIRSE BIEN',
            style: GoogleFonts.notoSerif(
              fontSize: 40,
              color: Colors.green.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Bienvenido a este hogar de Tranquilidad, Descanso y Relajación',
            style: GoogleFonts.dancingScript(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade800,
            ),
            textAlign: TextAlign.center,            
          ),
          const SizedBox(height: 10),
          Text(
            'Todo el mundo busca lugares donde relajarse y recargar energía. En nuestro centro de bienestar nos damos cita al silencio, la energía, la belleza y la vitalidad.\nLos tratamientos que ofrecemos refrescarán tanto tu cuerpo como tu alma.\nEstaremos encantados de recibirte.',
            style: GoogleFonts.cardo(
              fontSize: 20,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
            
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              InfoBox(
                imagePath: '../assets/images/inicio/spa1.webp',
                title: '¿Qué deseamos?',
                content:
                    'Crear experiencias únicas y personalizadas, donde cada detalle está diseñado para que nuestros clientes logren desconectarse de la rutina y se sumerjan en un oasis de calma y relajación, en completa armonía con la naturaleza.',
              ),
              InfoBox(
                imagePath: '../assets/images/inicio/spa2.webp',
                title: '¿Qué buscamos?',
                content:
                    'Ser los referentes en bienestar, conocidos por innovar en tratamientos que no solo cuidan el cuerpo, sino que también revitalizan el espíritu, ofreciendo un refugio perfecto para la mente y el cuerpo.',
              ),
              InfoBox(
                imagePath: '../assets/images/inicio/spa3.webp',
                title: '¿Cómo lo haremos?',
                content:
                    'Nos comprometemos a mantener los más altos estándares en cada servicio, asegurando que cada cliente reciba atención personalizada, utilizando productos de la mejor calidad y técnicas avanzadas en cada tratamiento.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
