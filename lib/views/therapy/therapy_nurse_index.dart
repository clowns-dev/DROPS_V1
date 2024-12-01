import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/tools/session_manager.dart';
import 'package:ps3_drops_v1/view_models/therapy_view_model.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_balances_data.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_patients_data.dart';
import 'package:ps3_drops_v1/widgets/error_form_dialog.dart';
import 'package:ps3_drops_v1/widgets/text_label.dart';
import 'package:ps3_drops_v1/widgets/title_container.dart';
import 'package:ps3_drops_v1/widgets/history_title_container.dart';
import 'package:ps3_drops_v1/widgets/search_field.dart';
import 'package:ps3_drops_v1/widgets/success_dialog.dart';

class TherapyNurseIndex extends StatefulWidget {
  const TherapyNurseIndex({super.key});

  @override
  State<TherapyNurseIndex> createState() => _TherapyNurseIndexState();
}

class _TherapyNurseIndexState extends State<TherapyNurseIndex> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchNurseController = TextEditingController();
  final TextEditingController _searchPatientController = TextEditingController();
  final TextEditingController _searchBalanceController = TextEditingController();
  final TextEditingController _stretcherNumberController = TextEditingController();
  int? idBalance, idPatient; 

  Therapy? therapy;


  Map<String, bool> _fieldErrors = {
    'stretcherNumber': false,
    'stretcherNumberInvalid': false,
    'idBalance': false,
    'idPatient': false,
  };

  void _resetFieldErrors(){
    setState(() {
      _fieldErrors = {
        'stretcherNumber': false,
        'stretcherNumberInvalid': false,
        'idBalance': false,
        'idPatient': false,
      };
    });
  }

  @override
  void initState() {
    super.initState();
    final therapyViewModel = context.read<TherapyViewModel>();
    therapyViewModel.fetchTherapyBalances(context);
    therapyViewModel.fetchTherapyPatients(context);
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchNurseController.dispose();
    super.dispose();
  }

  void _filterPatientList(String query) {
    final therapyViewModel = context.read<TherapyViewModel>();
    therapyViewModel.filterPatients(query);
  }

  void _filterBalanceList(String query) {
    final therapyViewModel = context.read<TherapyViewModel>();
    therapyViewModel.filterBalances(query);
  }

  void _resetForm(){
    final therapyViewModel = context.read<TherapyViewModel>();

    _stretcherNumberController.clear();
    _searchBalanceController.clear();
    _searchPatientController.clear();
    therapyViewModel.updateSelectedPatientId(0);
    therapyViewModel.updateSelectedBalanceId(0);
    _filterBalanceList('');
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
              _resetForm();
              _resetFieldErrors();
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
        idNurse: sessionManager.idUser,
        idBalance: idBalance,
        idPerson: idPatient,
        userID: sessionManager.idUser 
      );

      therapyViewModel.createNewTherapy(context, therapy!).then((_) {
        // ignore: use_build_context_synchronously
        therapyViewModel.fetchAllInfoNurseTherapies(context, sessionManager.idUser!);
        _resetFieldErrors();
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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleContainer(
              title: 'Gestión de Terapias',
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
                child: _buildForm(context),
              ),
            ),
          ],
        ),
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
                crossAxisAlignment: CrossAxisAlignment.start, 
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

  Widget _buildBalancesTable() {
    return Consumer<TherapyViewModel>(
      builder: (context, therapyViewModel, child) {
        if (therapyViewModel.isLoading) {
          // Muestra un indicador de carga mientras se están cargando los datos
          return const Center(child: CircularProgressIndicator());
        } else if (therapyViewModel.filteredBalances.isEmpty) {
          // Muestra el mensaje "Sin coincidencias" cuando no hay registros
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
          // Construye la tabla solo cuando hay registros
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