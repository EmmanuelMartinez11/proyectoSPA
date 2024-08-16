import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_flutter/utils/crud_clientes.dart';

// App Colors
class AppColors {
  static const Color backColor = Color(0xffF6F6F6);
  static const Color mainBlueColor = Color(0xff005BE0);
  static const Color blueDarkColor = Color(0xff252B5C);
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
    return MediaQuery.of(context).size.width < 600;
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

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        String userType = userDoc['tipo_usuario'];

        // Almacenar el tipo de usuario en GlobalUserType
        GlobalUserType.setUserType(userType);

        // Redirigir a la pantalla principal
        Navigator.pushReplacementNamed(context, '/inicio');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario no encontrado en Firestore')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      print('Error durante el inicio de sesión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!ResponsiveWidget.isSmallScreen(context))
              Expanded(
                child: Container(
                  height: height,
                  color: AppColors.mainBlueColor,
                  child: Center(
                    child: Text(
                      'AdminExpress',
                      style: ralewayStyle.copyWith(
                        fontSize: 48.0,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w800,
                      ),
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
                              text: 'Let’s',
                              style: ralewayStyle.copyWith(
                                fontSize: 25.0,
                                color: AppColors.blueDarkColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: ' Sign In 👇',
                              style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.blueDarkColor,
                                fontSize: 25.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        'Hey, Enter your details to get sign in \nto your account.',
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: height * 0.064),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Email',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueDarkColor,
                            fontSize: 12.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.email,
                              color: AppColors.blueDarkColor,
                            ),
                            contentPadding: const EdgeInsets.only(top: 16.0),
                            hintText: 'Enter Email',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor.withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.014),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Password',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: AppColors.whiteColor,
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueDarkColor,
                            fontSize: 12.0,
                          ),
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.blueDarkColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: AppColors.blueDarkColor,
                            ),
                            contentPadding: const EdgeInsets.only(top: 16.0),
                            hintText: 'Enter Password',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor.withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
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
                                'Sign In',
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
}
