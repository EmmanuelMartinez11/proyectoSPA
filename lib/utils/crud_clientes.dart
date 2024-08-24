import 'package:cloud_firestore/cloud_firestore.dart';

// global_user_type.dart
class GlobalUserType {
  static String _userType = '';

  static String getUserType() => _userType;

  static void setUserType(String userType) {
    _userType = userType;
  }
}

class CrudOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Agregar un cliente
  Future<void> addClient(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('clientes').doc(uid).set(data);
  }

  // Agregar un administrador
  Future<void> addAdmin(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('administradores').doc(uid).set(data);
  }

  // Actualizar un cliente
  Future<void> updateClient(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('clientes').doc(uid).update(data);
  }

  // Actualizar un administrador
  Future<void> updateAdmin(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('administradores').doc(uid).update(data);
  }

  // Eliminar un cliente
  Future<void> deleteClient(String uid) async {
    if (uid == null) {
      print('UID es null');
      return;
    }

    try {
      await _firestore.collection('clientes').doc(uid).delete();
    } catch (e) {
      print('Error al eliminar el cliente: $e');
    }
  }

  // Eliminar un administrador
  Future<void> deleteAdmin(String uid) async {
    if (uid == null) {
      print('UID es null');
      return;
    }

    try {
      await _firestore.collection('administradores').doc(uid).delete();
    } catch (e) {
      print('Error al eliminar el administrador: $e');
    }
  }

  // Obtener clientes
  Stream<List<Map<String, dynamic>>> getClients() {
    return _firestore
        .collection('clientes')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final uid = doc.id;
              data['uid'] = uid;
              return data;
            }).toList());
  }

  // Obtener administradores
  Stream<List<Map<String, dynamic>>> getAdmins() {
    return _firestore
        .collection('administradores')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final uid = doc.id;
              data['uid'] = uid;
              return data;
            }).toList());
  }
}
