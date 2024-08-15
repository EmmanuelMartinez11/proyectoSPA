import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoBox extends StatefulWidget {
  final String imagePath;
  final String title;
  final String content;

  InfoBox({required this.imagePath, required this.title, required this.content});

  @override
  _InfoBoxState createState() => _InfoBoxState();
}

class _InfoBoxState extends State<InfoBox> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: Container(
        width: 320, // Ajusta el ancho según sea necesario
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imagePath),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(15), // Borde pequeño a los lados
                padding: const EdgeInsets.all(10),
                color: Colors.white.withOpacity(0.8), // Recuadro blanco transparente
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 200),
                      style: GoogleFonts.notoSerif(
                        color: Colors.black,
                        fontSize: _isHovered ? 20 : 16, // Agranda el texto al pasar el mouse
                        fontWeight: FontWeight.bold,
                      ),
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 5),
                    AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 200),
                      style: GoogleFonts.notoSerif(
                        color: Colors.black87,
                        fontSize: _isHovered ? 18 : 14, // Agranda el texto al pasar el mouse
                      ),
                      child: Text(
                        widget.content,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onHover(bool hovering) {
    setState(() {
      _isHovered = hovering;
    });
  }
}
