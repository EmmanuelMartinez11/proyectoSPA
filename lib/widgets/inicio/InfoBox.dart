import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoBox extends StatelessWidget {
  final String imagePath;
  final String title;
  final String content;

  InfoBox({required this.imagePath, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320, 

      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
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
          child: Align(
            alignment: Alignment.bottomCenter, 
            child: Container(
              width: double.infinity, 
              height: 250, 
              margin: const EdgeInsets.all(15), 
              padding: const EdgeInsets.all(10),
              color: Colors.white.withOpacity(0.8), 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, 
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerif(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerif(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}