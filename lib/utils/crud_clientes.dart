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

  Future<void> addUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('usuarios').doc(uid).set(data);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('usuarios').doc(uid).update(data);
  }

  Future<void> deleteUser(String uid) async {
    if (uid == null) {
      print('UID es null');
      return;
    }

    try {
      await _firestore.collection('usuarios').doc(uid).delete();
    } catch (e) {
      print('Error al eliminar el usuario: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getUsers() {
    return _firestore
        .collection('usuarios')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final uid = doc.id; // Asegúrate de incluir el ID del documento
              data['uid'] = uid; // Agrega el ID al mapa de datos
              return data;
            }).toList());
  }
}
