import 'package:flutter/foundation.dart';
import '../models/patient.dart';
import '../services/api_service_patient.dart';

class PatientViewModel extends ChangeNotifier {
  ApiServicePatient apiServicePatient = ApiServicePatient();
  List<Patient> listPatients = [];
  List<Patient> filteredPatients = [];
  bool isLoading = false;
  bool hasMatches = true;


  PatientViewModel() {
    fetchPatients();
    
  }


  Future<void> fetchPatients() async {
    isLoading = true;
    notifyListeners();
    try {
      listPatients = await apiServicePatient.fetchPatients();
      filteredPatients = List.from(listPatients); 
      if (kDebugMode) {
        print('Pacientes cargados: ${listPatients.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener los registros de Pacientes: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterEmployees(String query) {
  if (kDebugMode) {
    print('Filtrando pacientes con consulta: $query');
  } 
  if (query.isEmpty) {
    filteredPatients = List.from(listPatients);
  } else {
    filteredPatients = listPatients.where((patient) {
      return patient.ci.toLowerCase().contains(query.toLowerCase()) ||
             patient.name.toLowerCase().contains(query.toLowerCase()) ||
             patient.lastName.toLowerCase().contains(query.toLowerCase()) ||
             patient.secondLastName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
  notifyListeners();
}







  void deletePatient(int patientId) {
    listPatients.removeWhere((patient) => patient.idPatient == patientId);
    filterEmployees(''); 
    notifyListeners();
  }
}
