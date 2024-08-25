import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_flutter/widgets/ingresar_registrar/ingresar.dart';

class RegistrarPersonal extends StatefulWidget {
  @override
  _RegistrarPersonalState createState() => _RegistrarPersonalState();
}

class _RegistrarPersonalState extends State<RegistrarPersonal> {
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'Masajista';

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
      });
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await FirebaseFirestore.instance
            .collection('personal')
            .doc(userCredential.user!.uid)
            .set({
          'nombres': _nombresController.text,
          'apellidos': _apellidosController.text,
          'fecha_nacimiento': Timestamp.fromDate(
              DateTime.parse(_fechaNacimientoController.text)),
          'email': _emailController.text,
          'telefono': int.parse(_telefonoController.text),
          'rol': _selectedRole,
          'tipo_usuario': 'personal'
        });

        Navigator.pushReplacementNamed(context, '/inicio');
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.1),
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
                                text: ' Register 👇',
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
                          'Por favor ingresa tus datos para crear una cuenta.',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: height * 0.064),
                        buildTextField(
                            'Nombres', _nombresController, TextInputType.text,
                            icon: Icons.person),
                        SizedBox(height: height * 0.014),
                        buildTextField('Apellidos', _apellidosController,
                            TextInputType.text,
                            icon: Icons.person),
                        SizedBox(height: height * 0.014),
                        buildTextField(
                          'Fecha de Nacimiento',
                          _fechaNacimientoController,
                          TextInputType.datetime,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          icon: Icons.calendar_today,
                        ),
                        SizedBox(height: height * 0.014),
                        buildTextField('Correo electrónico', _emailController,
                            TextInputType.emailAddress,
                            icon: Icons.mail),
                        SizedBox(height: height * 0.014),
                        buildTextField('Teléfono', _telefonoController,
                            TextInputType.phone,
                            icon: Icons.phone),
                        SizedBox(height: height * 0.014),
                        buildTextField(
                          'Contraseña',
                          _passwordController,
                          TextInputType.text,
                          icon: Icons.lock,
                        ),
                        SizedBox(height: height * 0.02),
                        buildDropdown(
                          'Rol',
                          _selectedRole,
                          [
                            'Masajista',
                            'Esteticista',
                            'Especialista en facial',
                            'Especialista en tratamientos corporales',
                          ],
                          (String? newValue) {
                            setState(() {
                              _selectedRole = newValue!;
                            });
                          },
                        ),
                        SizedBox(height: height * 0.05),
                        Material(
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
                      ],
                    ),
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
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
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
                contentPadding: const EdgeInsets.only(top: 16.0),
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
      ),
    );
  }

  Widget buildDropdown(String labelText, String selectedValue,
      List<String> options, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
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
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Icon(
                    Icons.person, // Icono de una persona
                    color: AppColors.blueDarkColor,
                  ),
                ),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedValue,
                      onChanged: onChanged,
                      items:
                          options.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: ralewayStyle.copyWith(
                              color: AppColors.blueDarkColor,
                              fontSize: 12.0,
                            ),
                          ),
                        );
                      }).toList(),
                      hint: Text(
                        'Selecciona $labelText',
                        style: ralewayStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.blueDarkColor.withOpacity(0.5),
                          fontSize: 12.0,
                        ),
                      ),
                      isExpanded: true,
                      style: ralewayStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.blueDarkColor,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
