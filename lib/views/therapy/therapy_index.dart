import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/view_models/therapy_view_model.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_balances_data.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_data.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_nurses_data.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_patients_data.dart';
import 'package:ps3_drops_v1/widgets/title_container.dart';
import 'package:ps3_drops_v1/widgets/history_title_container.dart';
import 'package:ps3_drops_v1/widgets/search_field.dart';
import 'package:ps3_drops_v1/widgets/dropdown_filter.dart';
import 'package:ps3_drops_v1/widgets/add_title_button.dart';
import 'package:ps3_drops_v1/widgets/success_dialog.dart';

class TherapyIndex extends StatefulWidget {
  const TherapyIndex({super.key});

  @override
  State<TherapyIndex> createState() => _TherapyIndexState();
}

class _TherapyIndexState extends State<TherapyIndex> {
  final String _selectedFilter = 'Buscar por:';
  final List<String> _filterOptions = ['Buscar por:', 'Codigo'];
  final TextEditingController _searchController = TextEditingController();
  bool _showForm = false;
  InfoTherapy? _selectedInfoTherapy;
  bool _isViewingTherapy = false;

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
    // therapyViewModel.filterBalances(_searchController.text);
  }

  void _toggleView({bool isViewing = false}) {
    setState(() {
      _showForm = !_showForm;
      _isViewingTherapy = isViewing;

      if (!_showForm) {
        _selectedInfoTherapy = null; // Reseteamos la terapia seleccionada cuando regresamos a la tabla
      }
    });
  }



  void _onViewTherapy(int id) async {
    final therapyViewModel = context.read<TherapyViewModel>();
    await therapyViewModel.fetchInfoTherapy(id);
    setState(() {
      _selectedInfoTherapy = therapyViewModel.infoTherapy;
      _toggleView(isViewing: true); // Llama a toggleView para pasar al estado de vista/lectura
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
                padding: const EdgeInsets.all(18.0),
                child: _showForm
                        ? (_isViewingTherapy
                            ? (_selectedInfoTherapy != null
                                ? _buildFormInfo(_selectedInfoTherapy!)
                                : const Center(child: CircularProgressIndicator()))
                            : _buildForm(context))
                        : _buildTable(),


              ),
            ),
          ],
        ),
      ),
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
              _onViewTherapy(id);
            },
          );
        }
      },
    );
  }

  Widget _buildFormInfo(InfoTherapy infoTherapy) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título
            const Text(
              'Ver registro',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24.0),

            // Contenedor de las tres columnas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Primera columna
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTableRow('ID Terapia', infoTherapy.idTherapy.toString()),
                      _buildTableRow('CI Enfermera', infoTherapy.ciNurse.toString()),
                      _buildTableRow('CI Paciente', infoTherapy.ciPatient.toString()),
                      _buildTableRow('Nro. Cama', infoTherapy.stretcherNumber.toString()),
                    ],
                  ),
                ),

                const SizedBox(width: 16.0),

                // Segunda columna
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTableRow('Tiempo ideal [hrs]', infoTherapy.idealTime.toString()),
                      _buildTableRow('Tiempo total [hrs]', infoTherapy.totalTime.toString()),
                      _buildTableRow('Volumen [ml]', infoTherapy.volumen.toString()),
                      _buildTableRow('Número de Burbujas', infoTherapy.numberBubbles.toString()),
                      _buildTableRow('Número de Bloqueos', infoTherapy.numberBlocks.toString()),
                      _buildTableRow('Numero de Ambos(Bloqueo y Burbuja))', infoTherapy.numberBoth.toString()),
                    ],
                  ),
                ),

                const SizedBox(width: 16.0),

                // Tercera columna
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTableRow('Fecha Inicio asignación', infoTherapy.startDate.toString()),
                      _buildTableRow('Fecha Fin asignación', infoTherapy.finishDate.toString()),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32.0),

            // Botón para volver
            ElevatedButton(
              onPressed: _toggleView,
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
              child: const Text(
                'Volver',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etiqueta
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity, // El contenedor principal utiliza todo el ancho disponible.
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            const Center(child: HistoryTitleContainer(titleTable: 'Crear Terapia')),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centrar la fila que contiene el input y el botón.
              children: [
                SizedBox(
                  width: 400, // Establece un ancho fijo para centrar el input y el botón.
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStretcherNumberInput(),
                      ),
                      const SizedBox(width: 24.0),
                      ElevatedButton(
                        onPressed: () {
                          _showSuccessDialog(context);
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
                        child: const Text(
                          'Asignar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    flex: 1, 
                    child: _buildPatientsTable(),
                  ),
                  const SizedBox(width: 16.0),
                  Flexible(
                    flex: 1,
                    child: _buildNursesTable(),
                  ),
                  const SizedBox(width: 16.0),
                  Flexible(
                    flex: 1,
                    child: _buildBalancesTable(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStretcherNumberInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Número de Camilla:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            hintText: 'Ingrese el número de la Camilla',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientsTable() {
    return Consumer<TherapyViewModel>(
      builder: (context, therapyViewModel, child) {
        if (therapyViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (therapyViewModel.listPatients.isEmpty) {
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
          return TherapyPatientsDataTable(
            therapyPatients: therapyViewModel.listPatients,
            selectedId: therapyViewModel.selectedPatientId, 
            onAssign: (int id) {
              therapyViewModel.updateSelectedPatientId(id); 
            },
          );
        }
      },
    );
  }

  Widget _buildNursesTable() {
    return Consumer<TherapyViewModel>(
      builder: (context, therapyViewModel, child) {
        if (therapyViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (therapyViewModel.listNurses.isEmpty) {
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
          return TherapyNursesDataTable(
            therapyNurses: therapyViewModel.listNurses,
            selectedId: therapyViewModel.selectedPatientId, 
            onAssign: (int id) {
              therapyViewModel.updateSelectedPatientId(id); 
            },
          );
        }
      },
    );
  }

  Widget _buildBalancesTable() {
    return Consumer<TherapyViewModel>(
      builder: (context, therapyViewModel, child) {
        if (therapyViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (therapyViewModel.listBalances.isEmpty) {
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
          return TherapyBalancesDataTable(
            therapyBalances: therapyViewModel.listBalances,
            selectedId: therapyViewModel.selectedPatientId, 
            onAssign: (int id) {
              therapyViewModel.updateSelectedPatientId(id); 
            },
          );
        }
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SuccessDialog(
          title: 'Registro Exitoso',
          message: '¡Se creó el registro correctamente!',
          onBackPressed: () {
            Navigator.of(context).pop(); // Cerrar el modal
            _toggleView(); // Volver a la vista de la tabla
          },
        );
      },
    );
  }
}