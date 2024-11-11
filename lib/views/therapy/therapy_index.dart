import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/view_models/therapy_view_model.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_balances_data.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_data.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_nurses_data.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_patients_data.dart';
import 'package:ps3_drops_v1/widgets/error_form_dialog.dart';
import 'package:ps3_drops_v1/widgets/text_label.dart';
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
  String _selectedFilter = 'Buscar por:';
  final List<String> _filterOptions = ['Buscar por:', 'CI Paciente', 'CI Enfermero', 'Camilla'];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchNurseController = TextEditingController();
  final TextEditingController _searchPatientController = TextEditingController();
  final TextEditingController _searchBalanceController = TextEditingController();
  final TextEditingController _stretcherNumberController = TextEditingController();
  int? idNurse, idBalance, idPatient; 

  bool _showForm = false;
  InfoTherapy? _selectedInfoTherapy;
  Therapy? therapy;
  bool _isViewingTherapy = false;

  Map<String, bool> _fieldErrors = {
    'stretcherNumber': false,
    'stretcherNumberInvalid': false,
    'idNurse': false,
    'idBalance': false,
    'idPatient': false,
  };

  void _resetFieldErrors(){
    setState(() {
      _fieldErrors = {
        'stretcherNumber': false,
        'stretcherNumberInvalid': false,
        'idNurse': false,
        'idBalance': false,
        'idPatient': false,
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
    _searchNurseController.dispose();
    super.dispose();
  }

  void _filteredTherapyList(String query) {
    final therapyViewModel = context.read<TherapyViewModel>();
    therapyViewModel.filterTherapies(query, _selectedFilter);
  }

  void _filterPatientList(String query) {
    final therapyViewModel = context.read<TherapyViewModel>();
    therapyViewModel.filterPatients(query);
  }

  void _filterNurseList(String query) {
    final therapyViewModel = context.read<TherapyViewModel>();
    therapyViewModel.filterNurses(query);
  }

  void _filterBalanceList(String query) {
    final therapyViewModel = context.read<TherapyViewModel>();
    therapyViewModel.filterBalances(query);
  }

  void _toggleView([Therapy? therapy]) {
    setState(() {
      _showForm = !_showForm;
      
      if (!_showForm) {
        _resetForm();
      } else {
        _resetFieldErrors();
      }
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

  void _clearSearch() {
    _searchController.clear();
    _filteredTherapyList('');
  }

  void _resetForm(){
    final therapyViewModel = context.read<TherapyViewModel>();

    _stretcherNumberController.clear();
    _searchBalanceController.clear();
    _searchNurseController.clear();
    _searchPatientController.clear();
    therapyViewModel.updateSelectedPatientId(0);
    therapyViewModel.updateSelectedNurseId(0);
    therapyViewModel.updateSelectedBalanceId(0);
    _filterBalanceList('');
    _filterNurseList('');
    _filterPatientList('');
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SuccessDialog(
          title: 'Registro Exitoso',
          message: '¡Se creó la Terapia correctamente!',
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

  void _showErrorFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ErrorDialog(
          title:'Faltan datos',
          message: '¡Faltan datos necesarios para la creacion!',
          onBackPressed: () {
            Navigator.of(context).pop(); 
          },
        );
      },
    );
  }

  void _validateAndSubmit(){
    setState(() {
      _fieldErrors['stretcherNumber'] = _stretcherNumberController.text.trim().isEmpty;
      _fieldErrors['stretcherNumberInvalid'] = !RegExp(r'^[a-zA-Z0-9\s\-_/\\]+$').hasMatch(_stretcherNumberController.text.trim());
      _fieldErrors['idNurse'] = idNurse == null || idNurse == 0;
      _fieldErrors['idBalance'] = idBalance == null || idBalance == 0;
      _fieldErrors['idPatient'] = idPatient == null || idPatient == 0;
    });

    if(_fieldErrors.containsValue(true)){
      _showErrorFormDialog(context);
      return;
    }

    final therapyViewModel = context.read<TherapyViewModel>();

    try{
      therapy = Therapy(
        stretcherNumber: _stretcherNumberController.text,
        idNurse: idNurse,
        idBalance: idBalance,
        idPerson: idPatient,
        userID: 29 /**  * ! Cambiar por el di capturado del usuario cuando se loguea. */ 
      );

      therapyViewModel.createNewTherapy(therapy!).then((_) {
        therapyViewModel.fetchTherapies();
        _clearSearch();
        _resetForm();
        if(mounted){
          _showSuccessDialog(context);
        }
      });


    }catch (e){
      throw Exception("Error Index: $e");
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
            if(!_showForm)
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
                        onChanged: (newValue) {
                          setState(() {
                            _selectedFilter = newValue as String;
                          });
                          if(_selectedFilter == 'Buscar por:'){
                            _filteredTherapyList('');
                          }
                        },
                      ),
                      const SizedBox(width: 16.0),
                      SearchField(
                        controller: _searchController,
                        fullWidth: false,
                        onChanged: (query) {
                          _filteredTherapyList(query);
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
        } else if (!therapyViewModel.hasMatches) {
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
                      _buildTableRow('Tiempo ideal [hrs]', infoTherapy.idealTime?.toString() ?? 'Sin Informacion Disponible'),
                      _buildTableRow('Tiempo total [hrs]', infoTherapy.totalTime?.toString() ?? 'Sin Informacion Disponible'),
                      _buildTableRow('Volumen [ml]', infoTherapy.volumen?.toString() ?? 'Sin Informacion Disponible'),
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
                      _buildTableRow('Fecha Inicio Asignación', infoTherapy.startDateAssing?.toString() ?? 'Sin fecha de Inicio'),
                      _buildTableRow('Fecha Fin Asignación', infoTherapy.finishDateAssing?.toString() ?? 'Sin fecha de Fin'),
                      _buildTableRow('Fecha Inicio Terapia', infoTherapy.startDate?.toString() ?? 'Sin fecha de Inicio'),
                      _buildTableRow('Fecha Fin Terapia', infoTherapy.finishDate?.toString() ?? 'Sin fecha de Fin'),
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
        width: double.infinity, 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            const Center(child: HistoryTitleContainer(titleTable: 'Crear Terapia')),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                SizedBox(
                  width: 400, 
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStretcherNumberInput(),
                      ),
                      const SizedBox(width: 24.0),
                      ElevatedButton(
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
                crossAxisAlignment: CrossAxisAlignment.start, // Cambiado a start para alinearlos en la parte superior
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Pacientes',
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10.0),
                            SearchField(
                              controller: _searchPatientController,
                              fullWidth: false,
                              onChanged: (query) {
                                _filterPatientList(query);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Expanded( // Cambiado a Expanded para ocupar espacio restante
                          child: _buildPatientsTable(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Enfermeros',
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10.0),
                            SearchField(
                              controller: _searchNurseController,
                              fullWidth: false,
                              onChanged: (query) {
                                _filterNurseList(query);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Expanded( // Cambiado a Expanded para ocupar espacio restante
                          child: _buildNursesTable(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Balanzas',
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10.0),
                            SearchField(
                              controller: _searchBalanceController,
                              fullWidth: false,
                              onChanged: (query) {
                                _filterBalanceList(query);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Expanded( // Cambiado a Expanded para ocupar espacio restante
                          child: _buildBalancesTable(),
                        ),
                      ],
                    ),
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
        const TextLabel(content: 'CI:'),
        const SizedBox(height: 8.0),
        TextField(
          controller: _stretcherNumberController,
          onChanged: (_) {
            setState(() {
              _fieldErrors['stretcherNumber'] = _stretcherNumberController.text.trim().isEmpty;
              _fieldErrors['stretcherNumberInvalid'] = !RegExp(r'^[a-zA-Z0-9\s\-_/\\]+$').hasMatch(_stretcherNumberController.text.trim());
            });
          }, 
          decoration: InputDecoration(
            hintText: 'Ingrese el número de la Camilla',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: _fieldErrors['stretcherNumber']! ? Colors.red : Colors.grey),
            ),
            errorText: _fieldErrors['stretcherNumber']! ? 'Campo obligatorio' : _fieldErrors['stretcherNumberInvalid']! ? 'Camilla Invalida' : null,
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
        } else if (!therapyViewModel.hasMatchesPatients) {
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
            therapyPatients: therapyViewModel.filteredPatients,
            selectedId: therapyViewModel.selectedPatientId,
            onAssign: (int id) {
               idPatient = therapyViewModel.updateSelectedPatientId(id);
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
        } else if (!therapyViewModel.hasMatchesNurses) {
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
            therapyNurses: therapyViewModel.filteredNurses,
            selectedId: therapyViewModel.selectedNurseId, 
            onAssign: (int id) {
              idNurse = therapyViewModel.updateSelectedNurseId(id); 
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
        } else if (!therapyViewModel.hasMatchesBalances) {
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
            therapyBalances: therapyViewModel.filteredBalances,
            selectedId: therapyViewModel.selectedBalanceId, 
            onAssign: (int id) {
              idBalance = therapyViewModel.updateSelectedBalanceId(id); 
            },
          );
        }
      },
    );
  }
}