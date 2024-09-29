import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/models/patient.dart';
import 'package:ps3_drops_v1/view_models/patient_view_model.dart';
import 'package:ps3_drops_v1/views/patient/patient_data.dart';
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

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final patientViewModel = context.read<PatientViewModel>();
    patientViewModel.filterEmployees(_searchController.text);
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
                        onChanged: (value) => _onSearchChanged(),
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
            const Text(
              'CI:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: TextEditingController(
                text: _editingPatient?.ci ?? '',
              ),
              decoration: InputDecoration(
                hintText: 'Ingrese el CI',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Campo para Nombre
            const Text(
              'Nombre:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: TextEditingController(
                text: _editingPatient?.name ?? '',
              ),
              decoration: InputDecoration(
                hintText: 'Ingrese el nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Campo para Apellido Paterno
            const Text(
              'Apellido Paterno:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: TextEditingController(
                text: _editingPatient?.lastName ?? '',
              ),
              decoration: InputDecoration(
                hintText: 'Ingrese el apellido paterno',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Campo para Apellido Materno
            const Text(
              'Apellido Materno:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: TextEditingController(
                text: _editingPatient?.secondLastName ?? '',
              ),
              decoration: InputDecoration(
                hintText: 'Ingrese el apellido materno',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Campo para Fecha de Nacimiento
            const Text(
              'Fecha de nacimiento:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: TextEditingController(
                text: _editingPatient?.birthDate ?? '',
              ),
              decoration: InputDecoration(
                hintText: 'dd/mm/aaaa',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 32.0),

            // Botón para guardar
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_editingPatient != null) {
                    if (kDebugMode) {
                      print('Editando paciente con ID: ${_editingPatient?.idPatient}');
                    }
                  } else {
                    if (kDebugMode) {
                      print('Creando nuevo paciente');
                    }
                  }

                  // Mostrar el modal de éxito después de guardar o editar
                  _showSuccessDialog(context, _editingPatient != null);
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
            Navigator.of(context).pop(); // Cerrar el modal
            _toggleView(); // Volver a la vista de la tabla
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int patientId) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmationDialog(
          onConfirmDelete: () {
            Provider.of<PatientViewModel>(context, listen: false).deletePatient(patientId);
            if (kDebugMode) {
              print('Eliminando paciente con ID: $patientId');
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
            onEdit: (id) {
              Patient? patient = patientViewModel.listPatients.firstWhere(
                (p) => p.idPatient == id,
                orElse: () => Patient(name: '', lastName: '', secondLastName: '', birthDate: '', ci: ''),
              );
              // ignore: unnecessary_null_comparison
              if (patient != null) {
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