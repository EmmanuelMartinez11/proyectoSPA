import 'package:flutter/material.dart';

class NoticiasPage extends StatelessWidget {
  final Key? key;

  const NoticiasPage({this.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      height: 300, // Altura fija de 600 píxeles,
      child: Text("Página de noticias"),
    );
  }
}
