import 'package:flutter/foundation.dart';
import '../models/patient.dart';
import '../services/api_service_patient.dart';

class PatientViewModel extends ChangeNotifier{
  ApiServicePatient apiServicePatient = ApiServicePatient();
  List<Patient> listPatients = [];
  bool isLoading = false;

  PatientViewModel() {
    fetchPatients();
  }

  Future<void> fetchPatients() async {
  isLoading = true;
  notifyListeners();
  try {
    listPatients = await apiServicePatient.fetchPatients();
    if (kDebugMode) {
      print('Pacientes cargados: ${listPatients.length}');
    } // Verificar cuántos pacientes se cargaron
  } catch (e) {
    if (kDebugMode) {
      print('Error al obtener los registros de Pacientes: $e');
    }
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

}