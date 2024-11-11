import 'package:flutter/foundation.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/services/api_service_therapy.dart';

class TherapyViewModel extends ChangeNotifier {
  ApiServiceTherapy apiServiceTherapy = ApiServiceTherapy();
  List<Therapy> listTherapies = [];
  List<Therapy> filteredTherapies = [];
  List<Nurse> filteredNurses = [];
  List<Patient> filteredPatients = [];
  List<Balance> filteredBalances = [];
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

  TherapyViewModel() {
    fetchTherapies();
    fetchTherapyPatients();
    fetchTherapyNurses();
    fetchTherapyBalances();
  }

  Future<void> fetchTherapies() async {
    isLoading = true;
    notifyListeners();
    try {
      listTherapies = await apiServiceTherapy.fetchTherapies();
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

  Future<void> createNewTherapy(Therapy newTherapy) async {
    try {
      if (newTherapy.idPerson != null && newTherapy.idNurse != null && newTherapy.idBalance != null && newTherapy.stretcherNumber != null) {
        await apiServiceTherapy.createTherapy(newTherapy);
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

  Future<void> fetchTherapyPatients() async {
    isLoading = true;
    notifyListeners();
    try {
      listPatients = await apiServiceTherapy.fetchTherapyPatients();
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

  Future<void> fetchTherapyNurses() async {
    isLoading = true;
    notifyListeners();
    try {
      listNurses = await apiServiceTherapy.fetchTherapyNurses();
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

  Future<void> fetchTherapyBalances() async {
    isLoading = true;
    notifyListeners();
    try {
      listBalances = await apiServiceTherapy.fetchTherapyBalances();
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

  Future<void> fetchInfoTherapy(int therapyId) async {
    isLoading = true;
    selectedTherapyId = therapyId;
    notifyListeners();
    try {
      infoTherapy = await apiServiceTherapy.fetchInfoTherapy(selectedTherapyId!);

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
