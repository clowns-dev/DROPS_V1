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
  final String _selectedFilter = 'Nombre';
  final List<String> _filterOptions = ['Nombre', 'CI', 'Apellido'];
  bool _showForm = false; 
  Patient? _editingPatient; 
  //String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Inputs del Formulario
  final TextEditingController _patientName = TextEditingController();
  final TextEditingController _patientLastName = TextEditingController();
  final TextEditingController _patientSecondLastName = TextEditingController();
  final TextEditingController _patientBirthDate = TextEditingController();
  final TextEditingController _patientCI = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  


  void _toggleView([Patient? patient]) {
    setState(() {
      _showForm = !_showForm;
      _editingPatient = patient; 
    });
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
                          
                        },
                      ),
                      const SizedBox(width: 16.0),
                      SearchField(
                        controller: _searchController,
                        fullWidth: false,
                        
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
                padding: const EdgeInsets.all(18.0), // Añadir padding al contenedor
                child: _showForm ? _buildForm() : _buildTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetForm() {
    _patientCI.clear();
    _patientName.clear();
    _patientLastName.clear();
    _patientSecondLastName.clear();
    _patientBirthDate.clear();
    _editingPatient = null; 
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
                titleTable: _editingPatient == null ? 'Añadir Usuario' : 'Editar Usuario',
              ),
            ),
            const SizedBox(height: 24.0),

            // Campo para CI
            const TextLabel(content: 'CI:'),
            const SizedBox(height: 8.0),
            TextField(
              controller: _patientCI,
              decoration: InputDecoration(
                hintText: 'Ingrese el CI',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Campo para Nombre
            const TextLabel(content: 'Nombre:'),
            const SizedBox(height: 8.0),
            TextField(
              controller: _patientName,
              decoration: InputDecoration(
                hintText: 'Ingrese el nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Campo para Apellido Paterno
            const TextLabel(content: 'Apellido Paterno:'),
            const SizedBox(height: 8.0),
            TextField(
              controller: _patientLastName,
              decoration: InputDecoration(
                hintText: 'Ingrese el apellido paterno',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Campo para Apellido Materno
            const TextLabel(content: 'Apellido Materno:'),
            const SizedBox(height: 8.0),
            TextField(
              controller: _patientSecondLastName,
              decoration: InputDecoration(
                hintText: 'Ingrese el apellido materno',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Campo para Fecha de Nacimiento
            const TextLabel(content: 'Fecha de Nacimiento:'),
            const SizedBox(height: 8.0),
            InkWell(
              onTap: () {
                _showSyncfusionDatePicker(context); // Llamada para abrir el Syncfusion DatePicker
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: 'Seleccione una fecha',
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  _patientBirthDate.text.isEmpty
                      ? 'Seleccione una fecha'
                      : _patientBirthDate.text, // Mostrar la fecha seleccionada
                ),
              ),
            ),



            const SizedBox(height: 32.0),

            // Botón para guardar
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String name = _patientName.text;
                  String lastName = _patientLastName.text;
                  String secondLastName = _patientSecondLastName.text;
                  String ci = _patientCI.text;
                  DateTime? birthDate;
                  if (_patientBirthDate.text.isNotEmpty) {
                    birthDate = DateFormat('dd/MM/yyyy').parse(_patientBirthDate.text);
                  }
                  final patientViewModel = context.read<PatientViewModel>();
                  if (_editingPatient != null) {
                    if (name.isNotEmpty && lastName.isNotEmpty && birthDate != null && ci.isNotEmpty) {
                      patientViewModel.editPatient(
                        _editingPatient!.idPatient!, name, lastName, secondLastName, birthDate, ci, 1
                      ).then((_) {
                        patientViewModel.fetchPatients();
                      });
                      _resetForm();
                      _showSuccessDialog(context, true);
                    }
                  } else {
                    if (name.isNotEmpty && lastName.isNotEmpty  && birthDate != null && ci.isNotEmpty) {
                      final patientViewModel = context.read<PatientViewModel>();
                    
                      patientViewModel.createNewPatient(name, lastName, secondLastName, birthDate, ci, 1).then((_) {
                        patientViewModel.fetchPatients();
                      });
                      _resetForm();
                      _showSuccessDialog(context, false);
                    }
                  }
                },
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

  DateTime? _selectedDate;

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
            _toggleView(); 
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

  Widget _buildTable() {
    return Consumer<PatientViewModel>(
      builder: (context, patientViewModel, child) {
        if (patientViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (patientViewModel.filteredPatients.isEmpty) {
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
                // Asigna los valores recuperados a los controladores del formulario
                setState(() {
                  _patientCI.text = patient.ci;
                  _patientName.text = patient.name;
                  _patientLastName.text = patient.lastName;
                  _patientSecondLastName.text = patient.secondLastName ?? '';
                  _patientBirthDate.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(patient.birthDate.toString()));
                  _editingPatient = patient; // Para saber que estamos en modo edición
                });

                _toggleView(patient); // Abre el formulario con los datos recuperados
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