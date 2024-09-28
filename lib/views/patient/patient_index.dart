import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/view_models/patient_view_model.dart';
import 'package:ps3_drops_v1/views/patient/patient_data.dart';
import 'package:ps3_drops_v1/widgets/title_container.dart';
import 'package:ps3_drops_v1/widgets/history_title_container.dart';
import 'package:ps3_drops_v1/widgets/search_field.dart';
import 'package:ps3_drops_v1/widgets/dropdown_filter.dart';
import 'package:ps3_drops_v1/widgets/add_title_button.dart';

class PatientIndex extends StatefulWidget {
  const PatientIndex({super.key});

  @override
  State<PatientIndex> createState() => _PatientIndexState();
}

class _PatientIndexState extends State<PatientIndex> {
  String _selectedFilter = 'Nombre';
  final List<String> _filterOptions = ['Nombre', 'CI', 'Fecha de Nacimiento'];
  bool _showForm = false; // Variable booleana para alternar entre tabla y formulario

  // Alterna entre mostrar la tabla o el formulario
  void _toggleView() {
    setState(() {
      _showForm = !_showForm;
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
                    onPressed: _toggleView,
                  );
                } else {
                  return OutlinedButton(
                    onPressed: _toggleView,
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
            // Fila con el título, filtro y buscador (en una sola línea)
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
                            _selectedFilter = newValue ?? _selectedFilter;
                          });
                        },
                      ),
                      const SizedBox(width: 16.0),
                      SearchField(fullWidth: false),
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

  // Widget para el formulario de añadir usuario
Widget _buildForm() {
  return Center(
    child: Container(
      width: 400, // Ajusta el ancho del formulario para que sea más simétrico y compacto
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: HistoryTitleContainer(titleTable: 'Añadir Usuario'),
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
                // Lógica para añadir un paciente
                _toggleView(); // Volver a la vista de la tabla tras añadir el paciente
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade300, // Color del botón
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 32.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'INSERTAR',
                style: TextStyle(
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




  // Widget para la tabla de pacientes
  Widget _buildTable() {
    return Consumer<PatientViewModel>(
      builder: (context, patientViewModel, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: PatientDataTable(
            patients: patientViewModel.listPatients,
            onEdit: (id) {
              if (kDebugMode) {
                print('Editando paciente con ID: $id');
              }
            },
            onDelete: (id) {
              if (kDebugMode) {
                print('Eliminando paciente con ID: $id');
              }
            },
          ),
        );
      },
    );
  }
}
