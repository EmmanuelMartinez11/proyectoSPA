import 'package:flutter/material.dart';
import 'package:proyecto_flutter/utils/crud_turnos.dart';
import '../button.dart';

class SacarTurnoButton extends StatefulWidget {
  final String nombres;
  final String apellidos;

  SacarTurnoButton({required this.nombres, required this.apellidos});

  @override
  _SacarTurnoButtonState createState() => _SacarTurnoButtonState();
}

class _SacarTurnoButtonState extends State<SacarTurnoButton> {
  String? _selectedServicio;
  String? _selectedEspecialidad;
  String? _selectedPersonal;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TurnoService turnoService = TurnoService();
  List<String> _especialidades = [];
  List<Map<String, String>> _personales = [];
  List<TimeOfDay> _horariosOcupados = [];

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: () => _abrirModalSacarTurno(context),
      text: ('Sacar Turno'),
    );
  }

  void _abrirModalSacarTurno(BuildContext context) async {
    // Resetear variables al abrir el modal
    _selectedServicio = null;
    _selectedEspecialidad = null;
    _selectedPersonal = null;
    _selectedDate = null;
    _selectedTime = null;
    _especialidades = [];
    _personales = [];
    _horariosOcupados = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sacar Turno'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton<String>(
                    value: _selectedServicio,
                    hint: const Text('Selecciona un servicio'),
                    items: [
                      'Masajes',
                      'Belleza',
                      'Tratamientos Faciales',
                      'Tratamientos Corporales'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      setState(() {
                        _selectedServicio = newValue;
                        _selectedEspecialidad = null;
                        _selectedPersonal = null;
                        _especialidades = [];
                        _personales = [];
                        _horariosOcupados = [];
                      });
                      if (newValue != null) {
                        _especialidades = await turnoService
                            .obtenerEspecialidadesPorServicio(newValue);
                        _personales =
                            (await turnoService.obtenerPersonalesPorRol(
                                    _mapServicioARol(newValue)))
                                .map((doc) => {
                                      'id': doc.id,
                                      'nombre':
                                          '${doc['nombres']} ${doc['apellidos']}',
                                    })
                                .toList();
                      }
                      setState(() {});
                    },
                  ),
                  if (_selectedServicio != null)
                    DropdownButton<String>(
                      value: _selectedEspecialidad,
                      hint: const Text('Selecciona una especialidad'),
                      items: _especialidades.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedEspecialidad = newValue;
                          _selectedPersonal = null;
                          _horariosOcupados = [];
                        });
                      },
                    ),
                  if (_selectedEspecialidad != null)
                    DropdownButton<String>(
                      value: _selectedPersonal,
                      hint: const Text('Selecciona el personal a cargo'),
                      items: _personales.map((personal) {
                        return DropdownMenuItem<String>(
                          value: personal['id'],
                          child: Text(personal['nombre']!),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPersonal = newValue;
                          _horariosOcupados = [];
                        });
                      },
                    ),
                  if (_selectedPersonal != null)
                    Column(
                      children: [
                        const SizedBox(height: 8),
                       HoverButton(
                        onPressed: () async {
                          DateTime? pickedDate = await _selectDate(context);
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                              _updateHorariosOcupados();
                            });
                          }
                        },
                        text: _selectedDate == null
                            ? 'Selecciona la fecha'
                            : '${_selectedDate!.toLocal()}'.split(' ')[0],
                      ),
                        const SizedBox(height: 8),
                        HoverButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await _selectTime(context);
                            if (pickedTime != null) {
                              setState(() {
                                _selectedTime = pickedTime;
                                // Actualizar los horarios ocupados también al seleccionar la hora
                                _updateHorariosOcupados();
                              });
                            }
                          },
                          text: _selectedTime == null
                              ? 'Selecciona la hora'
                              : _selectedTime!.format(context),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (_selectedServicio != null &&
                    _selectedEspecialidad != null &&
                    _selectedPersonal != null &&
                    _selectedDate != null &&
                    _selectedTime != null) {
                  DateTime fechaHoraTurno = DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                    _selectedTime!.hour,
                    _selectedTime!.minute,
                  );

                  // Validar que la fecha y hora seleccionadas sean futuras
                  if (fechaHoraTurno.isBefore(DateTime.now())) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('No puedes reservar un turno en el pasado.'),
                      ),
                    );
                    return;
                  }

                  bool turnoOcupado =
                      await turnoService.verificarTurnoOcupado(fechaHoraTurno);

                  if (!turnoOcupado) {
                    String personalNombre = _personales.firstWhere((personal) =>
                        personal['id'] == _selectedPersonal)['nombre']!;

                    Map<String, dynamic> turnoData = {
                      'servicio': _selectedServicio,
                      'especialidad': _selectedEspecialidad,
                      'personal_a_cargo': personalNombre,
                      'fecha_turno': fechaHoraTurno,
                      'cliente': '${widget.nombres} ${widget.apellidos}'
                    };
                    await turnoService.crearTurno(turnoData);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('El turno ya está ocupado'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Complete todos los campos'),
                    ),
                  );
                }
              },
              child: const Text('Reservar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateHorariosOcupados() async {
    if (_selectedDate != null && _selectedServicio != null) {
      List<String> horariosOcupados =
          await turnoService.obtenerHorariosOcupados(
        _selectedDate!,
        _selectedServicio!,
      );

      setState(() {
        _horariosOcupados = horariosOcupados.map((horario) {
          final parts = horario.split(':');
          return TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        }).toList();
      });
    }
  }

  String _mapServicioARol(String servicio) {
    switch (servicio) {
      case 'Masajes':
        return 'Masajista';
      case 'Belleza':
        return 'Esteticista';
      case 'Tratamientos Faciales':
        return 'Especialista en facial';
      case 'Tratamientos Corporales':
        return 'Especialista en tratamientos corporales';
      default:
        return '';
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    return picked;
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    final List<TimeOfDay> availableTimes = List.generate(15, (index) {
      return TimeOfDay(hour: 8 + index, minute: 0); // Horas entre 8:00 y 22:00
    });

    final TimeOfDay? picked = await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Selecciona la hora'),
          children: availableTimes.map((TimeOfDay time) {
            final isOcupado = _horariosOcupados.contains(time);
            return SimpleDialogOption(
              onPressed: isOcupado
                  ? null
                  : () {
                      Navigator.pop(context, time);
                    },
              child: Text(
                time.format(context),
                style: TextStyle(
                  color: isOcupado ? Colors.grey : Colors.black,
                ),
              ),
            );
          }).toList(),
        );
      },
    );

    return picked;
  }
}
