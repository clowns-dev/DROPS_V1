import 'package:flutter/services.dart';
import 'package:ps3_drops_v1/widgets/error_exist_dialog.dart';
import 'package:ps3_drops_v1/widgets/error_form_dialog.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/models/patient.dart';
import 'package:ps3_drops_v1/view_models/patient_view_model.dart';
import 'package:ps3_drops_v1/views/patient/patient_data.dart';
import 'package:ps3_drops_v1/widgets/text_label.dart';
import 'package:ps3_drops_v1/widgets/title_container.dart';
import 'package:ps3_drops_v1/widgets/history_title_container.dart';
import 'package:ps3_drops_v1/widgets/search_field.dart';
import 'package:ps3_drops_v1/widgets/dropdown_filter.dart';
import 'package:ps3_drops_v1/widgets/add_title_button.dart';
import 'package:ps3_drops_v1/widgets/success_dialog.dart';
import 'package:ps3_drops_v1/widgets/delete_confirmation_dialog.dart';

class PatientIndex extends StatefulWidget {
  const PatientIndex({super.key});

  @override
  State<PatientIndex> createState() => _PatientIndexState();
}

class _PatientIndexState extends State<PatientIndex> {
  String _selectedFilter = 'Buscar por:';
  final List<String> _filterOptions = ['Buscar por:','Nombre', 'CI', 'Apellido'];
  bool _showForm = false; 
  Patient? _editingPatient,patient;
  DateTime? _selectedDate; 
  final TextEditingController _searchController = TextEditingController();
  // Inputs del Formulario
  final TextEditingController _patientName = TextEditingController();
  final TextEditingController _patientLastName = TextEditingController();
  final TextEditingController _patientSecondLastName = TextEditingController();
  final TextEditingController _patientBirthDate = TextEditingController();
  final TextEditingController _patientCI = TextEditingController();
  int? _valueRadioButtonGenre;

  Map<String, bool> _fieldErrors = {
    'ci': false,
    'name': false,
    'nameInvalid': false,
    'lastName': false,
    'lastNameInvalid': false,
    'secondLastName': false,
    'birthDate': false,
    'genre': false,
  };

  void _resetFieldErrors() {
    setState(() {
      _fieldErrors = {
        'ci': false,
        'name': false,
        'nameInvalid': false,
        'lastName': false,
        'lastNameInvalid': false,
        'secondLastName': false,
        'birthDate': false,
        'genre': false,
      };
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filteredPatientList(String query){
    final patientViewModel = context.read<PatientViewModel>();
    patientViewModel.filterPatients(query, _selectedFilter);
  }

  void _toggleView([Patient? patient]) {
    setState(() {
      _showForm = !_showForm;
      
      if (!_showForm) {
        _resetForm();
      } else {
        _resetFieldErrors();
      }

      _editingPatient = patient;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filteredPatientList('');
  }

  void _resetForm() {
    _patientCI.clear();
    _patientName.clear();
    _patientLastName.clear();
    _patientSecondLastName.clear();
    _editingPatient = null;
    _valueRadioButtonGenre = null;
    _patientBirthDate.clear();
    _editingPatient = null; 
  }

  void _showSyncfusionDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), 
          ),
          backgroundColor: const Color(0xFFF5F0FF), 
          content: SizedBox(
            height: 350,
            width: 350,
            child: Container(
              padding: const EdgeInsets.all(10), 
              decoration: BoxDecoration(
                color: const Color(0xFFF5F0FF), 
                borderRadius: BorderRadius.circular(20), 
                border: Border.all(
                  color: const Color.fromARGB(255, 168, 126, 207), 
                  width: 2, // Grosor del borde
                ),
              ),
              child: SfDateRangePicker(
                backgroundColor: const Color(0xFFF5F0FF), 
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  setState(() {
                    _selectedDate = args.value;
                    _patientBirthDate.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
                  });
                  Navigator.pop(context); 
                },
                selectionMode: DateRangePickerSelectionMode.single,
                initialSelectedDate: _selectedDate ?? DateTime.now(),
                minDate: DateTime(1900),
                maxDate: DateTime.now().subtract(const Duration(days: 1)),
                headerStyle: const DateRangePickerHeaderStyle(
                  backgroundColor: Color(0xFFF0E4FF),
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF4B0082),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                monthCellStyle: const DateRangePickerMonthCellStyle(
                  todayTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                  todayCellDecoration: BoxDecoration(
                    color: Color(0xFFFFD700),
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(
                    color: Colors.red,
                  ),
                  disabledDatesTextStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                selectionColor: const Color(0xFF6A0DAD), 
                rangeSelectionColor: const Color(0xFFE1BEE7), 
              ),
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9494),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(70, 31),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, bool isEditing) {
    showDialog(
      context: context,
      builder: (context) {
        return SuccessDialog(
          title: isEditing ? 'Edición exitosa' : 'Registro Exitoso',
          message: isEditing
              ? '¡Se modificó el registro correctamente!'
              : '¡Se creó el registro correctamente!',
          onBackPressed: () { 
            Navigator.of(context).pop();
            setState(() {
              _showForm = false;
            });
          },
        );
      },
    );
  }

  void _showErrorFormDialog(BuildContext context, bool isEditing) {
    showDialog(
      context: context,
      builder: (context) {
        return ErrorDialog(
          title: isEditing ? "Faltan datos" : 'Faltan datos',
          message: isEditing
              ? '¡Falta datos necesarios para la edicion!'
              : '¡Faltan datos necesarios para la creacion!',
          onBackPressed: () {
            Navigator.of(context).pop(); 
          },
        );
      },
    );
  }

  void _showErrorExistsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return UserExistsDialog(
          title: "Paciente Registrado",
          message:  'Paciente ya registrado!',
          onBackPressed: () {
            Navigator.of(context).pop(); 
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int? patientId) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmationDialog(
          onConfirmDelete: () {
            final patientViewModel = context.read<PatientViewModel>();
            if(patientId != null){
              patientViewModel.removePatient(patientId, 1).then((_){
                patientViewModel.fetchPatients();
              });
            }
          },
        );
      },
    );
  }

  void _validateAndSubmit() async {
    setState(() {
      _fieldErrors['ci'] = _patientCI.text.trim().isEmpty;
      _fieldErrors['name'] = _patientName.text.trim().isEmpty;
      _fieldErrors['nameInvalid'] = !RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(_patientName.text.trim());
      _fieldErrors['lastName'] = _patientLastName.text.trim().isEmpty;
      _fieldErrors['lastNameInvalid'] = !RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(_patientLastName.text.trim());
      _fieldErrors['secondLastName'] =  _patientSecondLastName.text.isNotEmpty && !RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(_patientSecondLastName.text.trim());
      if (_patientBirthDate.text.isEmpty) {
        _fieldErrors['birthDate'] = true;
      } else {
        final selectedDate = DateFormat('dd/MM/yyyy').parse(_patientBirthDate.text);
        final now = DateTime.now();
        if (selectedDate.isAfter(now) || selectedDate.isAtSameMomentAs(now)) {
          _fieldErrors['birthDate'] = true;
        } else {
          _fieldErrors['birthDate'] = false;
        }
      }
      _fieldErrors['genre'] = (_valueRadioButtonGenre == null);
    });

     if (_fieldErrors.containsValue(true)) {
      _showErrorFormDialog(context, _editingPatient != null);
      return;
    }

    final patientViewModel = context.read<PatientViewModel>();
    bool isCiRegistered = await patientViewModel.isCiRegistered(_patientCI.text.trim());

    if(isCiRegistered && _editingPatient == null){
      _showErrorExistsDialog();
      return;
    }

    if(_editingPatient != null){
      patient = Patient(
        idPatient: _editingPatient!.idPatient!,
        name: _patientName.text, 
        lastName: _patientLastName.text,
        secondLastName: _patientSecondLastName.text, 
        birthDate: DateFormat('dd/MM/yyyy').parse(_patientBirthDate.text), 
        ci: _patientCI.text,
        genre: (_valueRadioButtonGenre == 0) ? "M" : "F",
        userID: 29 // cambiar luego por el ID del usuario que se captura cuando el usuario se loguea.
      );

      patientViewModel.editPatient(patient!).then((_) {
        patientViewModel.fetchPatients();
        _clearSearch();
        _resetForm();
        if(mounted){
          _showSuccessDialog(context, true);
        }
      });
    } else {
      patient = Patient(
        name: _patientName.text, 
        lastName: _patientLastName.text,
        secondLastName: _patientSecondLastName.text, 
        birthDate: DateFormat('dd/MM/yyyy').parse(_patientBirthDate.text), 
        ci: _patientCI.text,
        genre: (_valueRadioButtonGenre == 0) ? "M" : "F",
        userID: 29 // cambiar luego por el ID del usuario que se captura cuando el usuario se loguea.
      );

      patientViewModel.createNewPatient(patient!).then((_) {
        patientViewModel.fetchPatients();
        _clearSearch();
        _resetForm();
        if(mounted){
          _showSuccessDialog(context, false);
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TitleContainer(
              title: 'Gestión de Pacientes',
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 500) {
                  return IconButton(
                    icon: Icon(
                      _showForm ? Icons.arrow_back : Icons.add,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    onPressed: () => _toggleView(),
                  );
                } else {
                  return OutlinedButton(
                    onPressed: () => _toggleView(),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      side: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _showForm ? Icons.arrow_back : Icons.add,
                          color: Colors.grey[700],
                          size: 20.0,
                        ),
                        const SizedBox(width: 8.0),
                        AddTitleButton(
                          titleButton: _showForm ? 'Volver' : 'Añadir Usuario',
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(236, 238, 240, 255),
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: const Color.fromARGB(236, 238, 240, 255),
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_showForm)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const HistoryTitleContainer(
                    titleTable: 'Historial de Pacientes',
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownFilter(
                        fullWidth: false,
                        value: _selectedFilter,
                        items: _filterOptions,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedFilter = newValue as String;
                          });
                          if(_selectedFilter == 'Buscar por:'){
                            _filteredPatientList('');
                          }
                        },
                      ),
                      const SizedBox(width: 16.0),
                      SearchField(
                        controller: _searchController,
                        fullWidth: false,
                        onChanged: (query){
                          _filteredPatientList(query);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18.0),
                child: _showForm ? _buildForm() : _buildTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Center(
      child: Container(
        width: 400, 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: HistoryTitleContainer(
                titleTable: _editingPatient == null ? 'Añadir Paciente' : 'Editar Paciente',
              ),
            ),
            const SizedBox(height: 7.0),

            // Campo para CI
            const TextLabel(content: 'CI:'),
            const SizedBox(height: 8.0),
            TextField(
              controller: _patientCI,
              onChanged: (_) => setState(() => _fieldErrors['ci'] = _patientCI.text.trim().isEmpty),
              inputFormatters: [
                LengthLimitingTextInputFormatter(15),
              ],
              decoration: InputDecoration(
                hintText: 'Ingrese el C.I.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: _fieldErrors['ci']! ? Colors.red : Colors.grey),
                ),
                errorText: _fieldErrors['ci']! ? 'Campo obligatorio' : null,
              ),
            ),
            const SizedBox(height: 7.0),
            // Campo para Nombre
            const TextLabel(content: 'Nombre:'),
            const SizedBox(height: 8.0),
            TextField(
              controller: _patientName,
              onChanged: (_) { 
                setState(() { 
                  _fieldErrors['name'] = _patientName.text.trim().isEmpty;
                  _fieldErrors['nameInvalid'] = !RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(_patientName.text.trim());
                });
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(15),
              ],
              decoration: InputDecoration(
                hintText: 'Ingrese el nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: _fieldErrors['name']! ? Colors.red : Colors.grey),
                ),
                errorText: _fieldErrors['name']! ? 'Campo obligatorio' : _fieldErrors['nameInvalid']! ? 'Nombre invalido' : null,
              ),
            ),
            const SizedBox(height: 7.0),
            // Campo para Apellido Paterno
            const TextLabel(content: 'Apellido Paterno:'),
            const SizedBox(height: 8.0),
             TextField(
                controller: _patientLastName,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(45),
                ],
                onChanged: (_) { 
                  setState(() { 
                    _fieldErrors['lastName'] = _patientLastName.text.trim().isEmpty;
                    _fieldErrors['lastNameInvalid'] = !RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(_patientLastName.text.trim());
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Ingrese el apellido paterno',
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: _fieldErrors['lastName']! ? Colors.red : Colors.grey),
                ),
                errorText: _fieldErrors['lastName']! ? 'Campo obligatorio' : _fieldErrors['lastNameInvalid']! ? 'Apellido invalido' : null,
              ),
            ),
            const SizedBox(height: 7.0),
            const TextLabel(content: 'Apellido Materno:'),
            const SizedBox(height: 8.0),
            TextField(
              controller: _patientSecondLastName,
              inputFormatters: [
                LengthLimitingTextInputFormatter(45),
              ],
              onChanged: (_) {
                setState(() {
                  _fieldErrors['secondLastName'] =  _patientSecondLastName.text.isNotEmpty && !RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(_patientSecondLastName.text.trim());
                });
              },
              decoration: InputDecoration(
                hintText: 'Ingrese el apellido materno (opcional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorText: _fieldErrors['secondLastName']! ? 'Apellido Invalido' : null,
              ),
            ),
            const SizedBox(height: 7.0),
            const TextLabel(content: 'Genero'),
            const SizedBox(height: 4.0),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<int>(
                    title: const Text('Masculino'),
                    value: 0,
                    groupValue: _valueRadioButtonGenre,
                    onChanged: (value) {
                      setState(() {
                        _valueRadioButtonGenre = value!;
                        _fieldErrors['genre'] = false;
                      });
                    },
                    activeColor: _fieldErrors['genre']! ? Colors.red : null,
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                  title: const Text('Femenino'),
                  value: 1,
                  groupValue: _valueRadioButtonGenre,
                  onChanged: (value) {
                       setState(() {
                        _valueRadioButtonGenre = value!;
                        _fieldErrors['genre'] = false;
                      });
                    },
                    activeColor: _fieldErrors['genre']! ? Colors.red : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7.0),
            const TextLabel(content: 'Fecha de Nacimiento:'),
            const SizedBox(height: 4.0),
            InkWell(
              onTap: () {
                _showSyncfusionDatePicker(context);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: 'Seleccione una fecha',
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: _fieldErrors['birthDate']! ? Colors.red : Colors.grey,
                    ),
                  ),
                  errorText: _fieldErrors['birthDate']! ? 'Fecha inválida o campo obligatorio' : null, 
                ),
                child: Text(
                  _patientBirthDate.text.isEmpty
                  ? 'Seleccione una fecha'
                  : _patientBirthDate.text,
                  style: TextStyle(
                    color: _fieldErrors['birthDate']! ? Colors.red : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22.0),
            Center(
              child: ElevatedButton(
                onPressed: _validateAndSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade300,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  _editingPatient == null ? 'INSERTAR' : 'GUARDAR',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    return Consumer<PatientViewModel>(
      builder: (context, patientViewModel, child) {
        if (patientViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (!patientViewModel.hasMatches) {
          return Center(
            child: Text(
              'Sin coincidencias',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          );
        } else {
          return PatientDataTable(
            patients: patientViewModel.filteredPatients,
            onEdit: (id) async {
              
              Patient? patient = await patientViewModel.fetchPatientById(id);

              if (patient != null) {
                setState(() {
                  _resetFieldErrors();
                  _patientCI.text = patient.ci;
                  _patientName.text = patient.name;
                  _patientLastName.text = patient.lastName;
                  _patientSecondLastName.text = patient.secondLastName ?? '';
                  _valueRadioButtonGenre = (patient.genre == 'M') ?  0 : 1;
                  _patientBirthDate.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(patient.birthDate.toString()));
                  _editingPatient = patient; 
                });
                _toggleView(patient); 
              }
            },
            onDelete: (id) {
              _showDeleteConfirmationDialog(context, id);
            },
          );
        }
      },
    );
  }
}