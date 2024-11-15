import 'package:flutter/foundation.dart';
import 'package:ps3_drops_v1/models/patient.dart';
import 'package:ps3_drops_v1/services/api_service_patient.dart';

class PatientViewModel extends ChangeNotifier {
  ApiServicePatient apiServicePatient = ApiServicePatient();
  List<Patient> listPatients = [];
  Patient? patient;
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

  Future<Patient?> fetchPatientById(int id) async {
    isLoading = true;
    try{
      patient = await apiServicePatient.fetchPatientById(id);
    } catch (e) {
      if(kDebugMode){
        print("Error al obtener el registro del Paciente.");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return patient;
  }

  Future<bool> isCiRegistered(String ci) async {
    try {
      return await apiServicePatient.verifyExistPatient(ci);
    } catch (e) {
      if (kDebugMode) {
        print('Error al verificar si el CI está registrado: $e');
      }
      return false;
    }
  }

  void filterPatients(String query, String field) {
    if (query.isEmpty || field == 'Buscar por:') {
      filteredPatients = List.from(listPatients);
    } else {
      switch (field) {
        case 'CI':
          filteredPatients = listPatients
              .where((patient) => patient.ci.toLowerCase().contains(query.toLowerCase()))
              .toList();
          break;
        case 'Nombre':
          filteredPatients = listPatients
              .where((smart) => smart.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
          break;
        case 'Apellido':
          filteredPatients = listPatients
              .where((smart) => smart.lastName.toLowerCase().contains(query.toLowerCase()))
              .toList();
          break;
        case 'Genero':
          filteredPatients = listPatients
              .where((smart) => smart.genre?.toLowerCase().contains(query.toLowerCase()) ?? false)
              .toList();
          break;
        default:
          filteredPatients = List.from(listPatients);
      }
    }

    hasMatches = filteredPatients.isNotEmpty;
    notifyListeners();
  }

  Future<void> editPatient(Patient updatePatient) async {
    try{
      // ignore: unnecessary_null_comparison
      if(updatePatient.idPatient != null && updatePatient.name != null && updatePatient.lastName != null  && updatePatient.birthDate != null && updatePatient.ci != null && updatePatient.userID != null){
        await apiServicePatient.updatePatient(updatePatient);

        if(kDebugMode){
          print("Paciente Editado Exitosamente!");
        } else {
          if(kDebugMode){
            print("Error: Faltan datos para la Edicion.");
          }
        }
      }
    } catch (e) {
      if (kDebugMode){
        print("Error: No se pudo actualizar al Paciente.\n Detalles: $e");
      }
    }
  }

  Future<void> removePatient(int? idPatient, int? userId) async {
    try {
      if(idPatient != null && userId != null){
        await apiServicePatient.deletePatient(idPatient, userId);

        if(kDebugMode){
          print("Paciente Eliminado Exitosamente!");
        } else {
          if(kDebugMode){
            print("Error: Faltan datos para la eliminacion.");
          }
        }
      }
    } catch (e){
      if (kDebugMode){
        print("Error: No se pudo eliminar al Paciente.\n Detalles: $e");
      }
    }
  }

  Future<void> createNewPatient(Patient newPatient) async {
    try {
      // ignore: unnecessary_null_comparison
      if(newPatient.name != null && newPatient.lastName != null && newPatient.birthDate != null && newPatient.ci != null && newPatient.userID != null){

        await apiServicePatient.createPatient(newPatient);

        if(kDebugMode){
          print("Paciente Creado Exitosamente!");
        } else {
          if(kDebugMode){
            print("Error: Faltan datos para la Creacion.");
          }
        }
      }
    } catch (e){
      if (kDebugMode){
        print("Error: No se pudo crear al Paciente.\n Detalles: $e");
      }
    }
  }
}
