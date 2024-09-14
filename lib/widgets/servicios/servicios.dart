import 'package:flutter/material.dart';

class ServiciosPage extends StatelessWidget {
  final Key? key;

  const ServiciosPage({this.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      height: 900, 
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/servicios/design.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
   child: Column(
     mainAxisAlignment: MainAxisAlignment.start,
     children: [
      Text(
        "Servicios Individuales",
        style: TextStyle(
          color: Colors.black,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          // fontStyle: FontStyle.italic, // Elimina esta línea
        ),
      ),
            SizedBox(height: 20),
            Expanded( 
              child: ListView(
                children: [
                  _buildCategory("Masajes", [
                    _buildServiceCard('Anti-stress', 'Relajación y bienestar total.', 'images/servicios/Anti-stress.jpg'),
                    _buildServiceCard('Masaje Descontracturante', 'Alivia tensiones y dolores musculares.', 'images/servicios/Masaje-Descontracturante.jpg'),
                    _buildServiceCard('Masaje con Piedras Calientes', 'Relajación profunda con terapia de calor.', 'images/servicios/Masaje-Piedras-Calientes.jpg'),
                    _buildServiceCard('Masaje Circulatorio', 'Mejora la circulación y reduce la fatiga.', 'images/servicios/Masaje-Circulatorio.jpg'),
                  ]),
                  _buildCategory("Belleza", [
                    _buildServiceCard('Lifting de Pestañas', 'Pestañas más largas y curvas de forma natural.', 'images/servicios/Lifting-Pestanas.jpg'),
                    _buildServiceCard('Depilación Facial', 'Elimina el vello no deseado de forma suave.', 'images/servicios/Depilacion-Facial.jpg'),
                    _buildServiceCard('Belleza de manos y pies', 'Manicura y pedicura profesional.', 'images/servicios/Belleza-Manos-Pies.jpg'),
                  ]),
                  _buildCategory("Tratamientos Faciales", [
                    _buildServiceCard('Punta de Diamante', 'Exfoliación y renovación celular profunda.', 'images/servicios/Punta-Diamante.jpg'),
                    _buildServiceCard('Limpieza Profunda e Hidratación', 'Purifica y revitaliza tu piel.', 'images/servicios/Limpieza-Profunda-Hidratacion.jpg'),
                    _buildServiceCard('Crio Frecuencia Facial', 'Rejuvenece y reafirma tu rostro.', 'images/servicios/Crio-Frecuencia-Facial.jpg'),
                  ]),
                  _buildCategory("Tratamientos Corporales", [
                    _buildServiceCard('VelaSlim', 'Modela tu figura y reduce la celulitis.', 'images/servicios/VelaSlim.jpg'),
                    _buildServiceCard('DermoHealth', 'Tratamiento especializado para la piel.', 'images/servicios/DermoHealth.jpg'),
                    _buildServiceCard('Crio Frecuencia Corporal', 'Reduce medidas y tonifica tu cuerpo.', 'images/servicios/Crio-Frecuencia-Corporal.jpg'),
                    _buildServiceCard('Ultracavitación', 'Elimina grasa localizada sin cirugía.', 'images/servicios/Ultracavitacion.jpg'),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(String categoryTitle, List<Widget> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text( 

            categoryTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Wrap( 
          alignment: WrapAlignment.start,
          spacing: 10,
          runSpacing: 10,
          children: services,
        ),
      ],
    );
  }

  Widget _buildServiceCard(String title, String description, String imagePath) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 3, 
      shape: RoundedRectangleBorder( 
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey[300]!,
          width: 1.0,
        ),
      ),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100], 
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              imagePath,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
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