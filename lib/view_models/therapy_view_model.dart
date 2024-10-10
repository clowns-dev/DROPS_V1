import 'package:flutter/foundation.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/services/api_service_therapy.dart';

class TherapyViewModel extends ChangeNotifier {
  ApiServiceTherapy apiServiceTherapy = ApiServiceTherapy();
  List<Therapy> listTherapies = [];
  List<Therapy> filteredTherapies = [];
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
      if (kDebugMode) {
        print('Terapias cargadas: ${listTherapies.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener los registros de Terapias: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createNewTherapy(String stretcherNumber, int userId) async {
    try {
      if (selectedPatientId != null && selectedNurseId != null && selectedBalanceId != null) {
        await apiServiceTherapy.createTherapy(
          selectedPatientId!,
          selectedNurseId!,
          selectedBalanceId!,
          stretcherNumber,
          userId,
        );
        if (kDebugMode) {
          print("Terapia creada exitosamente.");
        }
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
      if (kDebugMode) {
        print('Pacientes cargados: ${listPatients.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: Fallo al obtener los registros de Pacientes.');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTherapyNurses() async {
    isLoading = true;
    notifyListeners();
    try {
      listNurses = await apiServiceTherapy.fetchTherapyNurses();
      if (kDebugMode) {
        print('Enfermeros cargados: ${listPatients.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: Fallo al obtener los registros de Enfermeros.');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTherapyBalances() async {
    isLoading = true;
    notifyListeners();
    try {
      listBalances = await apiServiceTherapy.fetchTherapyBalances();
      if (kDebugMode) {
        print('Balanzas cargados: ${listPatients.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: Fallo al obtener los registros de Balanzas.');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInfoTherapy(int therapyId) async {
    isLoading = true;
    selectedTherapyId = therapyId;
    notifyListeners();
    try {
      if (kDebugMode) {
        print('Cargando información para terapia ID: $selectedTherapyId');
      }

      infoTherapy = await apiServiceTherapy.fetchInfoTherapy(selectedTherapyId!);

      if (kDebugMode) {
        print('Información de Terapia Cargada: ${infoTherapy?.idTherapy}');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al obtener la información de la Terapia: $e");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  void updateSelectedPatientId(int id) {
    selectedPatientId = id;
    notifyListeners(); 
  }

  void updateSelectedNurseId(int id) {
    selectedNurseId = id;
    notifyListeners(); 
  }

  void updateSelectedBalanceId(int id) {
    selectedBalanceId = id;
    notifyListeners(); 
  }
}
