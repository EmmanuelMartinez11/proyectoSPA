import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:google_fonts/google_fonts.dart';
import '../button.dart';

class CarouselWidget extends StatelessWidget {
  final List<Map<String, String>> items;
  final InfiniteScrollController carouselController;

  const CarouselWidget({required this.items, required this.carouselController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InfiniteCarousel.builder(
          controller: carouselController,
          itemCount: items.length,
          itemExtent: MediaQuery.of(context).size.width,
          center: true,
          anchor: 0.0,
          velocityFactor: 0.5,
          itemBuilder: (context, itemIndex, realIndex) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  items[itemIndex]["image"]!,
                  fit: BoxFit.cover,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        items[itemIndex]["title"]!,
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
                        items[itemIndex]["description"]!,
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
        Positioned(
          left: 10,
          top: MediaQuery.of(context).size.height / 2 - 25,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 50),
            onPressed: () {
              // Verifica que el controlador esté definido
              if (carouselController != null) {
                carouselController.previousItem();
              }
            },
          ),
        ),
        Positioned(
          right: 10,
          top: MediaQuery.of(context).size.height / 2 - 25,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 50),
            onPressed: () {
              // Verifica que el controlador esté definido
              if (carouselController != null) {
                carouselController.nextItem();
              }
            },
          ),
        ),
      ],
    );
  }
}
