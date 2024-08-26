import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_flutter/widgets/inicio_cliente/inicio_cliente.dart';
import 'package:proyecto_flutter/widgets/inicio_personal/inicio_personal.dart';
import 'package:proyecto_flutter/widgets/navbar.dart';

// App Colors
class AppColors {
  static const Color backColor = Color.fromARGB(255, 234, 219, 219);
  static const Color mainBlueColor = Color(0xFFCD4875);
  static const Color blueDarkColor = Color.fromARGB(255, 25, 28, 56);
  static const Color textColor = Color(0xff53587A);
  static const Color whiteColor = Color(0xffFFFFFF);
}

// Text Style
TextStyle ralewayStyle = GoogleFonts.raleway();

// Responsive Widget
class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;

  const ResponsiveWidget({
    Key? key,
    required this.largeScreen,
    this.mediumScreen,
    this.smallScreen,
  }) : super(key: key);

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 900;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width <= 1200;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return largeScreen;
        } else if (constraints.maxWidth <= 1200 &&
            constraints.maxWidth >= 600) {
          return mediumScreen ?? largeScreen;
        } else {
          return smallScreen ?? largeScreen;
        }
      },
    );
  }
}

// Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _showError =
      false; // Agregado para controlar la visibilidad del mensaje de error

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Buscar en la colección de clientes
      DocumentSnapshot clienteDoc = await FirebaseFirestore.instance
          .collection('clientes')
          .doc(userCredential.user!.uid)
          .get();

      if (clienteDoc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ClienteScreen(clienteDoc: clienteDoc),
          ),
        );
        return;
      }

      // Buscar en la colección de personal
      DocumentSnapshot personalDoc = await FirebaseFirestore.instance
          .collection('personal')
          .doc(userCredential.user!.uid)
          .get();

      if (personalDoc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PersonalScreen(personalDoc: personalDoc),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario no encontrado en ninguna colección')),
      );
    } catch (e) {
      setState(() {
        _showError = true; // Muestra el mensaje de error
      });
      print('Error durante el inicio de sesión: $e');
    }
  }

  void _showRegisterOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Registrarse como',
              style: ralewayStyle.copyWith(
                fontSize: 25.0,
                color: AppColors.blueDarkColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 16.0),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/registrar_cliente');
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: AppColors.mainBlueColor,
                    ),
                    child: Center(
                      child: Text(
                        'Cliente',
                        style: ralewayStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.whiteColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/registrar_personal');
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: AppColors.mainBlueColor,
                    ),
                    child: Center(
                      child: Text(
                        'Personal',
                        style: ralewayStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.whiteColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPasswordDialog() {
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contraseña requerida'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Ingrese la contraseña',
                ),
              ),
              SizedBox(height: 10),
              if (_passwordController.text.isNotEmpty &&
                  _passwordController.text != '123456')
                Text(
                  'Contraseña incorrecta',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el dialogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_passwordController.text == '123456') {
                  Navigator.pop(context); // Cierra el dialogo
                  Navigator.pushNamed(context, '/registrar_personal');
                } else {
                  setState(() {});
                }
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Altura del NavBar
        child: NavBar(), // Usa el NavBar como appBar
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!ResponsiveWidget.isSmallScreen(context))
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          '../assets/images/ingresar/ingresar.jpg'), // Ruta de la imagen en tu proyecto
                      fit: BoxFit.cover, // Ajusta la imagen al contenedor
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Container(
                height: height,
                margin: EdgeInsets.symmetric(
                    horizontal: ResponsiveWidget.isSmallScreen(context)
                        ? height * 0.032
                        : height * 0.12),
                color: AppColors.backColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.2),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Ingresá',
                              style: ralewayStyle.copyWith(
                                fontSize: 25.0,
                                color: AppColors.blueDarkColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.064),
                      buildTextField(
                        'Correo electrónico',
                        _emailController,
                        TextInputType.emailAddress,
                        icon: Icons.email,
                      ),
                      SizedBox(height: height * 0.014),
                      buildTextField(
                        'Contraseña',
                        _passwordController,
                        TextInputType.text,
                        obscureText: _obscurePassword,
                        icon: Icons.lock,
                      ),
                      // Mensaje de error
                      if (_showError)
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 8.0, bottom: 16.0),
                          child: Text(
                            'Usuario o contraseña incorrecto',
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          ),
                        ),
                      SizedBox(height: height * 0.03),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _showRegisterOptions,
                          child: Text(
                            '¿No tienes cuenta? ¡Registrate!',
                            style: ralewayStyle.copyWith(
                              fontSize: 12.0,
                              color: AppColors.mainBlueColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _signIn,
                          borderRadius: BorderRadius.circular(16.0),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70.0, vertical: 18.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: AppColors.mainBlueColor,
                            ),
                            child: Center(
                              child: Text(
                                'Ingresar',
                                style: ralewayStyle.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.whiteColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      TextInputType keyboardType,
      {bool obscureText = false,
      bool readOnly = false,
      VoidCallback? onTap,
      IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: ralewayStyle.copyWith(
            fontSize: 12.0,
            color: AppColors.blueDarkColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          width:
              double.infinity, // Asegura que el Container ocupe todo el ancho
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            style: ralewayStyle.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.blueDarkColor,
              fontSize: 12.0,
            ),
            keyboardType: keyboardType,
            obscureText: obscureText,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              prefixIcon: icon != null
                  ? Icon(icon, color: AppColors.blueDarkColor)
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0), // Ajusta el padding vertical
              hintText: 'Ingresa $labelText',
              hintStyle: ralewayStyle.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.blueDarkColor.withOpacity(0.5),
                fontSize: 12.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
