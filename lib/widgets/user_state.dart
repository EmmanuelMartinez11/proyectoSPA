import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserState with ChangeNotifier {
  String? _nombre;

  String? get nombre => _nombre;
  
  User? _user;

  User? get user => _user;

  void setNombre(String nombre) {
    _nombre = nombre;
    notifyListeners(); // Notifica a los widgets que escuchan este cambio
  }

  void clearNombre() {
    _nombre = null;
    notifyListeners();
  }
  UserState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }
}
