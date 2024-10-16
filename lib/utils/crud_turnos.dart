import 'package:cloud_firestore/cloud_firestore.dart';

class TurnoService {
  final CollectionReference turnosCollection =
      FirebaseFirestore.instance.collection('turnos');

  Future<void> crearTurno(Map<String, dynamic> turnoData) async {
    try {
      await turnosCollection.add(turnoData);
    } catch (e) {
      print('Error al crear el turno: $e');
    }
  }

  Future<List<DocumentSnapshot>> obtenerPersonalesPorRol(String rol) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('personal')
          .where('rol', isEqualTo: rol)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error al obtener el personal por rol: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> obtenerTurnosPersonal(
      String nombreCompleto) async {
    try {
      QuerySnapshot querySnapshot = await turnosCollection
          .where('personal_a_cargo', isEqualTo: nombreCompleto)
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'fecha_turno': doc['fecha_turno'],
          'servicio': doc['servicio'],
          'especialidad': doc['especialidad'],
          'cliente': doc['cliente'],
        };
      }).toList();
    } catch (e) {
      print('Error al obtener los turnos del personal: $e');
      return [];
    }
  }

  Future<List<String>> obtenerEspecialidadesPorServicio(String servicio) async {
    Map<String, List<String>> especialidades = {
      'Masajes': [
        'Anti-stress',
        'Descontracturantes',
        'Masajes con piedras calientes',
        'Circulatorios'
      ],
      'Belleza': [
        'Lifting de pestaña',
        'Depilación facial',
        'Belleza de manos y pies'
      ],
      'Tratamientos Faciales': [
        'Punta de Diamante: Microexfoliación',
        'Limpieza profunda + Hidratación',
        'Crio frecuencia facial'
      ],
      'Tratamientos Corporales': [
        'VelaSlim',
        'DermoHealth',
        'Criofrecuencia',
        'Ultracavitación'
      ]
    };

    return especialidades[servicio] ?? [];
  }

  Future<bool> verificarTurnoOcupado(DateTime fechaHoraTurno) async {
    try {
      QuerySnapshot querySnapshot = await turnosCollection
          .where('fecha_turno', isEqualTo: fechaHoraTurno)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error al verificar turno: $e');
      return false;
    }
  }

  Future<List<String>> obtenerHorariosOcupados(
      DateTime fecha, String servicio) async {
    try {
      QuerySnapshot querySnapshot = await turnosCollection
          .where('fecha_turno', isGreaterThanOrEqualTo: fecha)
          .where('fecha_turno', isLessThan: fecha.add(Duration(days: 1)))
          .where('servicio', isEqualTo: servicio)
          .get();

      return querySnapshot.docs.map((doc) {
        final fechaHora = (doc['fecha_turno'] as Timestamp).toDate();
        return '${fechaHora.hour.toString().padLeft(2, '0')}:${fechaHora.minute.toString().padLeft(2, '0')}';
      }).toList();
    } catch (e) {
      print('Error al obtener horarios ocupados: $e');
      return [];
    }
  }

  Future<void> actualizarTurno(
      String idTurno, Map<String, dynamic> turnoData) async {
    try {
      await turnosCollection.doc(idTurno).update(turnoData);
    } catch (e) {
      print('Error al actualizar el turno: $e');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerTurnosCliente(
      String nombreCompleto) async {
    try {
      QuerySnapshot querySnapshot = await turnosCollection
          .where('cliente', isEqualTo: nombreCompleto)
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'fecha_turno': doc['fecha_turno'],
          'servicio': doc['servicio'],
          'especialidad': doc['especialidad'],
          'personal_a_cargo': doc['personal_a_cargo'],
          'precio': doc['precio'],
          'estado': doc['estado'],
        };
      }).toList();
    } catch (e) {
      print('Error al obtener los turnos del cliente: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> obtenerTurnosPorFechaYPersonal(
      DateTime fecha, String nombreCompleto) async {
    try {
      QuerySnapshot querySnapshot = await turnosCollection
          .where('personal_a_cargo', isEqualTo: nombreCompleto)
          .where('fecha_turno',
              isGreaterThanOrEqualTo: Timestamp.fromDate(fecha))
          .where('fecha_turno',
              isLessThan: Timestamp.fromDate(fecha.add(Duration(days: 1))))
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'fecha_turno': doc['fecha_turno'],
          'servicio': doc['servicio'],
          'especialidad': doc['especialidad'],
          'cliente': doc['cliente'],
        };
      }).toList();
    } catch (e) {
      print('Error al obtener los turnos por fecha y personal: $e');
      return [];
    }
  }

  Future<void> cancelarTurno(String idTurno) async {
    try {
      await turnosCollection.doc(idTurno).delete();
    } catch (e) {
      print('Error al cancelar el turno: $e');
    }
  }

  Future<void> actualizarEstadoTurno(String idTurno, String nuevoEstado) async {
    try {
      await turnosCollection.doc(idTurno).update({'estado': nuevoEstado});
    } catch (e) {
      print('Error al actualizar el estado del turno: $e');
    }
  }
}
