import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_flutter/widgets/ingresar_registrar/ingresar.dart';
import 'package:proyecto_flutter/widgets/navbar.dart';

class RegistrarCliente extends StatefulWidget {
  @override
  _RegistrarClienteState createState() => _RegistrarClienteState();
}

class _RegistrarClienteState extends State<RegistrarCliente> {
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _nombresError;
  String? _apellidosError;
  String? _telefonoError;
  String? _passwordError;
  String? _emailError;
  String? _fechaNacimientoError;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _fechaNacimientoController.text =
            DateFormat('yyyy-MM-dd').format(picked);
        _fechaNacimientoError =
            null; // Limpiar el error al seleccionar la fecha
      });
    }
  }

  String? _validateNombres(String? value) {
    if (value == null || value.isEmpty) {
      return '*';
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'Solo se admiten letras';
    }
    return null;
  }

  String? _validateApellidos(String? value) {
    if (value == null || value.isEmpty) {
      return '*';
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'Solo se admiten letras';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '*';
    }
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Formato de correo electrónico inválido';
    }
    return null;
  }

  String? _validateFechaNacimiento(String? value) {
    if (value == null || value.isEmpty) {
      return '*';
    }
    return null;
  }

  String? _validateTelefono(String? value) {
    if (value == null || value.isEmpty) {
      return '*';
    }
    if (!RegExp(r'^\d{8,12}$').hasMatch(value)) {
      return 'Solo se admiten números de 8 a 12 caracteres';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '*';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  Future<void> _register() async {
    setState(() {
      _nombresError = _validateNombres(_nombresController.text);
      _apellidosError = _validateApellidos(_apellidosController.text);
      _telefonoError = _validateTelefono(_telefonoController.text);
      _passwordError = _validatePassword(_passwordController.text);
      _emailError = _validateEmail(_emailController.text);
      _fechaNacimientoError =
          _validateFechaNacimiento(_fechaNacimientoController.text);
    });

    if (_nombresError == null &&
        _apellidosError == null &&
        _telefonoError == null &&
        _passwordError == null &&
        _emailError == null &&
        _fechaNacimientoError == null) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await FirebaseFirestore.instance
            .collection('clientes')
            .doc(userCredential.user!.uid)
            .set({
          'nombres': _nombresController.text,
          'apellidos': _apellidosController.text,
          'fecha_nacimiento': Timestamp.fromDate(
              DateTime.parse(_fechaNacimientoController.text)),
          'email': _emailController.text,
          'telefono': int.parse(_telefonoController.text),
          'tipo_usuario': 'cliente'
        });

        Navigator.pushReplacementNamed(context, '/ingresar');
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Altura del NavBar
        child: NavBar(), // Usa el NavBar como appBar
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/masajes.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Formulario centrado
          Center(
            child: Container(
              width: width * 0.85,
              margin: EdgeInsets.symmetric(
                vertical: height * 0.05,
                horizontal: width * 0.05,
              ),
              padding: EdgeInsets.symmetric(
                vertical: height * 0.05,
                horizontal: width * 0.05,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 900;

                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.05),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Registro de cliente',
                                  style: ralewayStyle.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.blueDarkColor,
                                    fontSize: 30.0, // Tamaño más grande
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.05),
                          if (isWide)
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      buildTextField(
                                          'Nombres',
                                          _nombresController,
                                          TextInputType.text,
                                          icon: Icons.person,
                                          errorText: _nombresError,
                                          onChanged: (value) {
                                        setState(() {
                                          _nombresError =
                                              _validateNombres(value);
                                        });
                                      }),
                                      SizedBox(height: height * 0.02),
                                      buildTextField(
                                          'Fecha de Nacimiento',
                                          _fechaNacimientoController,
                                          TextInputType.datetime,
                                          readOnly: true,
                                          onTap: () => _selectDate(context),
                                          icon: Icons.calendar_today,
                                          errorText: _fechaNacimientoError),
                                      SizedBox(height: height * 0.02),
                                      buildTextField(
                                          'Teléfono',
                                          _telefonoController,
                                          TextInputType.phone,
                                          icon: Icons.phone,
                                          errorText: _telefonoError,
                                          onChanged: (value) {
                                        setState(() {
                                          _telefonoError =
                                              _validateTelefono(value);
                                        });
                                      }),
                                    ],
                                  ),
                                ),
                                SizedBox(width: width * 0.02),
                                Expanded(
                                  child: Column(
                                    children: [
                                      buildTextField(
                                          'Apellidos',
                                          _apellidosController,
                                          TextInputType.text,
                                          icon: Icons.person,
                                          errorText: _apellidosError,
                                          onChanged: (value) {
                                        setState(() {
                                          _apellidosError =
                                              _validateApellidos(value);
                                        });
                                      }),
                                      SizedBox(height: height * 0.02),
                                      buildTextField(
                                          'Correo electrónico',
                                          _emailController,
                                          TextInputType.emailAddress,
                                          icon: Icons.mail,
                                          errorText: _emailError,
                                          onChanged: (value) {
                                        setState(() {
                                          _emailError = _validateEmail(value);
                                        });
                                      }),
                                      SizedBox(height: height * 0.02),
                                      buildTextField(
                                          'Contraseña',
                                          _passwordController,
                                          TextInputType.text,
                                          icon: Icons.lock,
                                          errorText: _passwordError,
                                          obscureText: true,
                                          onChanged: (value) {
                                        setState(() {
                                          _passwordError =
                                              _validatePassword(value);
                                        });
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                buildTextField(
                                  'Nombres',
                                  _nombresController,
                                  TextInputType.text,
                                  icon: Icons.person,
                                  errorText: _nombresError,
                                  onChanged: (value) {
                                    setState(() {
                                      _nombresError = _validateNombres(value);
                                    });
                                  },
                                ),
                                SizedBox(height: height * 0.02),
                                buildTextField(
                                  'Apellidos',
                                  _apellidosController,
                                  TextInputType.text,
                                  icon: Icons.person,
                                  errorText: _apellidosError,
                                  onChanged: (value) {
                                    setState(() {
                                      _apellidosError =
                                          _validateApellidos(value);
                                    });
                                  },
                                ),
                                SizedBox(height: height * 0.02),
                                buildTextField(
                                  'Fecha de Nacimiento',
                                  _fechaNacimientoController,
                                  TextInputType.datetime,
                                  readOnly: true,
                                  onTap: () => _selectDate(context),
                                  icon: Icons.calendar_today,
                                  errorText: _fechaNacimientoError,
                                ),
                                SizedBox(height: height * 0.02),
                                buildTextField(
                                  'Correo electrónico',
                                  _emailController,
                                  TextInputType.emailAddress,
                                  icon: Icons.mail,
                                  errorText: _emailError,
                                  onChanged: (value) {
                                    setState(() {
                                      _emailError = _validateEmail(value);
                                    });
                                  },
                                ),
                                SizedBox(height: height * 0.02),
                                buildTextField(
                                  'Teléfono',
                                  _telefonoController,
                                  TextInputType.phone,
                                  icon: Icons.phone,
                                  errorText: _telefonoError,
                                  onChanged: (value) {
                                    setState(() {
                                      _telefonoError = _validateTelefono(value);
                                    });
                                  },
                                ),
                                SizedBox(height: height * 0.02),
                                buildTextField(
                                  'Contraseña',
                                  _passwordController,
                                  TextInputType.text,
                                  icon: Icons.lock,
                                  errorText: _passwordError,
                                  obscureText: true,
                                  onChanged: (value) {
                                    setState(() {
                                      _passwordError = _validatePassword(value);
                                    });
                                  },
                                ),
                              ],
                            ),
                          SizedBox(height: height * 0.05),
                          Center(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _register,
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
                                      'Registrar',
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
                          ),
                          SizedBox(height: height * 0.05),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      TextInputType keyboardType,
      {bool obscureText = false,
      bool readOnly = false,
      VoidCallback? onTap,
      IconData? icon,
      String? errorText,
      ValueChanged<String>? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              labelText,
              style: ralewayStyle.copyWith(
                fontSize: 12.0,
                color: AppColors.blueDarkColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (errorText != null && errorText == '*')
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12.0,
                ),
              ),
          ],
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
            onChanged: onChanged,
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
            validator: (value) {
              if (labelText == 'Nombres') return _validateNombres(value);
              if (labelText == 'Apellidos') return _validateApellidos(value);
              if (labelText == 'Correo electrónico')
                return _validateEmail(value);
              if (labelText == 'Fecha de Nacimiento')
                return _validateFechaNacimiento(value);
              if (labelText == 'Teléfono') return _validateTelefono(value);
              if (labelText == 'Contraseña') return _validatePassword(value);
              return null;
            },
          ),
        ),
        if (errorText != null && errorText.isNotEmpty && errorText != '*')
          Text(
            errorText,
            style: TextStyle(color: Colors.red, fontSize: 12.0),
          ),
      ],
    );
  }
}
