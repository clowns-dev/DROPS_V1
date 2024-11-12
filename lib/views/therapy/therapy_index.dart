import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/view_models/therapy_view_model.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_data.dart';
import 'package:ps3_drops_v1/widgets/text_label.dart';
import 'package:ps3_drops_v1/widgets/title_container.dart';
import 'package:ps3_drops_v1/widgets/history_title_container.dart';
import 'package:ps3_drops_v1/widgets/search_field.dart';
import 'package:ps3_drops_v1/widgets/dropdown_filter.dart';
import 'package:ps3_drops_v1/widgets/add_title_button.dart';
import 'package:ps3_drops_v1/widgets/success_dialog.dart';
import 'package:ps3_drops_v1/widgets/delete_confirmation_dialog.dart';

class TherapyIndex extends StatefulWidget {
  const TherapyIndex({super.key});

  @override
  State<TherapyIndex> createState() => _TherapyIndexState();
}

class _TherapyIndexState extends State<TherapyIndex> {
  final String _selectedFilter = 'Nombre';
  final List<String> _filterOptions = ['Nombre', 'CI', 'Apellido'];
  bool _showForm = false;
  Therapy? _editingTherapy;
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
    final therapyViewModel = context.read<TherapyViewModel>();
    therapyViewModel.filterTherapies(_searchController.text);
  }

  void _toggleView([Therapy? therapy]) {
    setState(() {
      _showForm = !_showForm;
      _editingTherapy = therapy;
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
              title: 'Gestión de Terapias',
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
                      side: BorderSide(
                          color: Colors.grey.withOpacity(0.6), width: 1.5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
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
                          titleButton: _showForm ? 'Volver' : 'Crear Terapia',
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
                    titleTable: 'Historial de Terapias',
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownFilter(
                        fullWidth: false,
                        value: _selectedFilter,
                        items: _filterOptions,
                        onChanged: (newValue) {},
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
                padding:
                    const EdgeInsets.all(18.0), // Añadir padding al contenedor
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
                titleTable: _editingTherapy == null
                    ? 'Añadir Terapia'
                    : 'Editar Terapia',
              ),
            ),
            const SizedBox(height: 24.0),

            // Campo para Tiempo Sugerido (Suggested Time)
            const TextLabel(content: 'Tiempo Sugerido:'),
            const SizedBox(height: 8.0),
            TextField(
              controller: TextEditingController(
                text: _editingTherapy?.suggestedTime.toString() ?? '',
              ),
              decoration: InputDecoration(
                hintText: 'Ingrese el tiempo sugerido',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Campo para Tiempo Extra (Extra Time)
            const TextLabel(content: 'Tiempo Extra:'),
            const SizedBox(height: 8.0),
            TextField(
              controller: TextEditingController(
                text: _editingTherapy?.extraTime.toString() ?? '',
              ),
              decoration: InputDecoration(
                hintText: 'Ingrese el tiempo extra',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Campo para Número de Camilla (Stretcher Number)
            const TextLabel(content: 'Número de Camilla:'),
            const SizedBox(height: 8.0),
            TextField(
              controller: TextEditingController(
                text: _editingTherapy?.stretcherNumber.toString() ?? '',
              ),
              decoration: InputDecoration(
                hintText: 'Ingrese el número de camilla',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Campo para Fecha de Inicio (Start Date)
            const TextLabel(content: 'Fecha de Inicio:'),
            const SizedBox(height: 8.0),
            TextField(
              controller: TextEditingController(
                text: _editingTherapy?.startDate.toString() ?? '',
              ),
              decoration: InputDecoration(
                hintText: 'Ingrese la fecha de inicio',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Campo para Volumen (Volume)
            const TextLabel(content: 'Volumen:'),
            const SizedBox(height: 8.0),
            TextField(
              controller: TextEditingController(
                text: _editingTherapy?.volume.toString() ?? '',
              ),
              decoration: InputDecoration(
                hintText: 'Ingrese el volumen',
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
                  if (_editingTherapy != null) {
                    if (kDebugMode) {
                      print(
                          'Editando terapia con ID: ${_editingTherapy?.idTherapy}');
                    }
                  } else {
                    if (kDebugMode) {
                      print('Creando nueva terapia');
                    }
                  }

                  // Mostrar el modal de éxito después de guardar o editar
                  _showSuccessDialog(context, _editingTherapy != null);
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
                  _editingTherapy == null ? 'INSERTAR' : 'GUARDAR',
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

  void _showDeleteConfirmationDialog(BuildContext context, int TherapyId) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmationDialog(
          onConfirmDelete: () {
            Provider.of<TherapyViewModel>(context, listen: false)
                .deleteTherapy(TherapyId);
            if (kDebugMode) {
              print('Eliminando terapia con ID: $TherapyId');
            }
          },
        );
      },
    );
  }

  Widget _buildTable() {
    return Consumer<TherapyViewModel>(
      builder: (context, therapyViewModel, child) {
        if (therapyViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (therapyViewModel.filteredTherapies.isEmpty) {
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
          return TherapyDataTable(
            therapies: therapyViewModel.filteredTherapies,
            onView: (id) {
              // Puedes definir la lógica que ocurre al presionar "Ver"
              Therapy? therapy = therapyViewModel.listTherapies.firstWhere(
                (t) => t.idTherapy == id,
                orElse: () => Therapy(
                    suggestedTime: 0,
                    extraTime: 0,
                    stretcherNumber: 0,
                    startDate: DateTime.now(),
                    volume: 0.0),
              );
              _toggleView(therapy);
            },
          );
        }
      },
    );
  }
}
