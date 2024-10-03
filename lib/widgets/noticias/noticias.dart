import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticiasPage extends StatelessWidget {
  final Key? key;

  const NoticiasPage({this.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      height: 700,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/noticia1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              "Noticias",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),
            _buildNewsCard(
              context, // Pasa el contexto a _buildNewsCard
              'El poder de la meditación para reducir el estrés',
              'Estudios recientes demuestran los beneficios de la meditación...',
              'assets/images/meditacion.png',
              'https://www.mayoclinic.org/es/tests-procedures/meditation/in-depth/meditation/art-20045858',
            ),
            SizedBox(height: 20),
            _buildNewsCard(
              context, // Pasa el contexto a _buildNewsCard
              'Alimentos que potencian tu belleza',
              'Descubre los superalimentos que nutren tu piel y cabello...',
              'assets/images/alimentos.png',
              'https://www.espacebeaute.com.ar/5-alimentos-con-propiedades-que-potencian-tu-belleza/',
            ),
            SizedBox(height: 20),
            _buildNewsCard(
              context, // Pasa el contexto a _buildNewsCard
              'Los masajes y su impacto en la salud',
              'Más allá de la relajación, los masajes pueden aliviar dolores...',
              'assets/images/massage.png',
              'https://www.mayoclinic.org/es/tests-procedures/massage-therapy/about/pac-20384595',
            ),
            // Agrega más tarjetas de noticias aquí...
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, String title, String excerpt,
      String imagePath, String url) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          // Muestra un diálogo de error si no se puede abrir el enlace
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('No se pudo abrir el enlace'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: ListTile(
          leading: Image.asset(imagePath),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(excerpt),
        ),
      ),
    );
  }
}
