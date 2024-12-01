import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/services/api_middleware.dart';
import 'package:ps3_drops_v1/services/api_service_therapy.dart';
import 'package:ps3_drops_v1/services/mqtt_service.dart';
import 'package:ps3_drops_v1/tools/session_manager.dart';
class TherapyViewModel extends ChangeNotifier {
  final ApiMiddleware _apiMiddleware = ApiMiddleware();
  late final ApiServiceTherapy apiServiceTherapy = ApiServiceTherapy(_apiMiddleware);
  final MqttService mqttService = MqttService();
  List<Therapy> listTherapies = [];
  List<Therapy> filteredTherapies = [];
  List<Nurse> filteredNurses = [];
  List<Patient> filteredPatients = [];
  List<Balance> filteredBalances = [];
  List<InfoTherapiesNurse> listNurseTherapies = [];
  List<InfoTherapiesNurse> listAsignTherapies = [];
  InfoTherapy? infoTherapy;
  int? selectedTherapyId;

  List<Patient> listPatients = [];
  int? selectedPatientId; 

  List<Nurse> listNurses = [];
  int? selectedNurseId; 

  List<Balance> listBalances = [];
  int? selectedBalanceId; 

  bool isLoading = false;
  bool hasMatches = true;
  bool hasMatchesPatients = true;
  bool hasMatchesNurses = true;
  bool hasMatchesBalances = true;
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  TherapyViewModel();
    
  Future<void> initializeMqtt(BuildContext context, List<InfoTherapiesNurse> listInfo) async {
    await mqttService.connect();
    _isConnected = mqttService.isConnected;
    notifyListeners();

    if (_isConnected) {
      subscribeToBalance(listInfo);
    }

    mqttService.listenToMessages((topic, payload) async {
        if(topic.contains('terapia')){
          if(sessionManager.idRole == 2){
            await fetchAllInfoNurseTherapies(context, sessionManager.idUser!);
            notifyListeners();
          } else if(sessionManager.idRole == 4){
            await fetchAllInfoAsignTherapies(context);
            notifyListeners();
          }
        }
      });
  }

  Future<void> subscribeToBalance(List<InfoTherapiesNurse> listTherapies) async {
    if (listTherapies.isNotEmpty) {
      for (var therapy in listTherapies) {
        final topic = 'drops/terapia/${therapy.idTherapy}';
        mqttService.subscribe(topic);
        if (kDebugMode) {
          print('Suscrito al tópico: $topic');
        }
      }
    } else {
      if (kDebugMode) {
        print('Error: Lista vacía, no se suscribieron tópicos.');
      }
    }
  }

  Future<void> fetchTherapies(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      listTherapies = await apiServiceTherapy.fetchTherapies(context);
      filteredTherapies = List.from(listTherapies); 
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener los registros de Terapias: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllInfoNurseTherapies(BuildContext context, int idNurse) async {
    isLoading = true;
    notifyListeners();
    try {
      listNurseTherapies = await apiServiceTherapy.fetchInfoNurseTherapies(context, idNurse);
      // ignore: use_build_context_synchronously
      await initializeMqtt(context, listNurseTherapies);
    } catch (e) {
      throw Exception('Fallo en la solicitud al servidor: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllInfoAsignTherapies(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      listAsignTherapies = await apiServiceTherapy.fetchInfoAssignmentTherapies(context);
      // ignore: use_build_context_synchronously
      await initializeMqtt(context, listAsignTherapies);
    } catch (e) {
      throw Exception('Fallo en la solicitud al servidor: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  void filterTherapies(String query, String field) {
    if (query.isEmpty || field == 'Buscar por:') {
      filteredTherapies = List.from(listTherapies);
    } else {
      switch (field) {
        case 'CI Enfermero':
          filteredTherapies = listTherapies
              .where((therapy) => therapy.ciNurse?.toLowerCase().contains(query.toLowerCase()) ?? false)
              .toList();
          break;
        case 'CI Paciente':
          filteredTherapies = listTherapies
              .where((therapy) => therapy.ciPatient?.toLowerCase().contains(query.toLowerCase()) ?? false)
              .toList();
          break;
        case 'Camilla':
          filteredTherapies = listTherapies
              .where((therapy) => therapy.stretcherNumber?.toLowerCase().contains(query.toLowerCase()) ?? false)
              .toList();
          break;
        default:
          filteredTherapies = List.from(listTherapies);
      }
    }
    hasMatches = filteredTherapies.isNotEmpty;
    notifyListeners();
  }

  Future<void> createNewTherapy(BuildContext context, Therapy newTherapy) async {
    try {
      if (newTherapy.idPerson != null && newTherapy.idNurse != null && newTherapy.idBalance != null && newTherapy.stretcherNumber != null) {
        await apiServiceTherapy.createTherapy(context, newTherapy);
        selectedPatientId = null;
        selectedNurseId = null;
        selectedBalanceId = null;
      } else {
        if (kDebugMode) {
          print("Error: Faltan datos de selección.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: No se pudo crear la terapia. Detalles: $e");
      }
    }
  }

  Future<void> fetchTherapyPatients(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      listPatients = await apiServiceTherapy.fetchTherapyPatients(context);
      filteredPatients = List.from(listPatients);
    } catch (e) {
      if (kDebugMode) {
        print('Error: Fallo al obtener los registros de Pacientes.');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterPatients(String query) {
    if (query.isEmpty) {
      filteredPatients = List.from(listPatients);
    } else {
      filteredPatients = listPatients.where((patient) {
        return patient.patient?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
    }
 
    hasMatchesPatients = filteredPatients.isNotEmpty;
    notifyListeners();
  }

  Future<void> fetchTherapyNurses(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      listNurses = await apiServiceTherapy.fetchTherapyNurses(context);
      filteredNurses = List.from(listNurses);
    } catch (e) {
      if (kDebugMode) {
        print('Error: Fallo al obtener los registros de Enfermeros.');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterNurses(String query) {
    if (query.isEmpty) {
      filteredNurses = List.from(listNurses);
    } else {
      filteredNurses = listNurses.where((nurse) {
        return nurse.fullName?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
    }
 
    hasMatches = filteredNurses.isNotEmpty;
    notifyListeners();
  }

  Future<void> fetchTherapyBalances(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      listBalances = await apiServiceTherapy.fetchTherapyBalances(context);
      filteredBalances = List.from(listBalances);
    } catch (e) {
      if (kDebugMode) {
        print('Error: Fallo al obtener los registros de Balanzas.');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterBalances(String query) {
    if (query.isEmpty) {
      filteredBalances = List.from(listBalances);
    } else {
      filteredBalances = listBalances.where((balance) {
        return balance.code?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
    }
 
    hasMatches = filteredBalances.isNotEmpty;
    notifyListeners();
  }

  Future<void> fetchInfoTherapy(BuildContext context, int therapyId) async {
    isLoading = true;
    selectedTherapyId = therapyId;
    notifyListeners();
    try {
      infoTherapy = await apiServiceTherapy.fetchInfoTherapy(context, selectedTherapyId!);

    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al obtener la información de la Terapia: $e");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  int? updateSelectedPatientId(int id) {
    selectedPatientId = id;
    notifyListeners(); 
    return selectedPatientId;
  }

  int? updateSelectedNurseId(int id) {
    selectedNurseId = id;
    notifyListeners(); 
    return selectedNurseId;
  }

  int? updateSelectedBalanceId(int id) {
    selectedBalanceId = id;
    notifyListeners();
    return selectedBalanceId; 
  }
}
