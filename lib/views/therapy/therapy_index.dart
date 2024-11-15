import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/view_models/therapy_view_model.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_balances_data.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_data.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_nurses_data.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_patients_data.dart';

class TherapyIndex extends StatefulWidget {
  const TherapyIndex({Key? key}) : super(key: key);

  @override
  State<TherapyIndex> createState() => _TherapyIndexState();
}

class _TherapyIndexState extends State<TherapyIndex> {
  final String _selectedFilter = 'Buscar por:';
  final List<String> _filterOptions = ['Buscar por:', 'Codigo'];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _stretcherNumberController =
      TextEditingController();
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
    // Implementar la lógica de búsqueda aquí si es necesario
  }

  void _toggleView({bool isViewing = false}) {
    final therapyViewModel = context.read<TherapyViewModel>();

    if (!_showForm) {
      therapyViewModel.updateSelectedPatientId(0);
      therapyViewModel.updateSelectedNurseId(0);
      therapyViewModel.updateSelectedBalanceId(0);
      _stretcherNumberController.clear();
    }

    setState(() {
      _showForm = !_showForm;
      _isViewingTherapy = isViewing;
    });
  }

  void _onViewTherapy(int id) async {
    final therapyViewModel = context.read<TherapyViewModel>();

    await therapyViewModel.fetchInfoTherapy(id);

    if (mounted) {
      setState(() {
        _selectedInfoTherapy = therapyViewModel.infoTherapy;
        _showForm = true;
        _isViewingTherapy = true;
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
            const Text('Gestión de Terapias'),
            IconButton(
              icon: Icon(
                _showForm ? Icons.arrow_back : Icons.add,
                color: Colors.black,
              ),
              onPressed: () => _toggleView(),
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
                const Text('Historial de Terapias'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: _selectedFilter,
                      items: _filterOptions
                          .map((String value) => DropdownMenuItem<String>(
                              value: value, child: Text(value)))
                          .toList(),
                      onChanged: (newValue) {
                        // Manejar el cambio en el filtro si es necesario
                      },
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Buscar...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _onSearchChanged(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _showForm
                  ? (_isViewingTherapy
                      ? (_selectedInfoTherapy != null
                          ? _buildFormInfo(_selectedInfoTherapy!)
                          : const Center(child: CircularProgressIndicator()))
                      : _buildForm(context))
                  : _buildTable(),
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
          return const Center(child: Text('Sin coincidencias'));
        } else {
          return TherapyDataTable(
            therapies: therapyViewModel.filteredTherapies,
            onView: (id) => _onViewTherapy(id),
          );
        }
      },
    );
  }

  Widget _buildFormInfo(InfoTherapy infoTherapy) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID Terapia: ${infoTherapy.idTherapy}'),
          Text('CI Enfermera: ${infoTherapy.ciNurse}'),
          Text('CI Paciente: ${infoTherapy.ciPatient}'),
          // Añade otros campos según sea necesario
          ElevatedButton(
            onPressed: _toggleView,
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextField(
            controller: _stretcherNumberController,
            decoration: const InputDecoration(
              hintText: 'Número de Camilla',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final therapyViewModel = context.read<TherapyViewModel>();
              // Lógica para crear una nueva terapia
            },
            child: const Text('Crear Terapia'),
          ),
        ],
      ),
    );
  }
}
