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

  Future<void> editPatient(int? idPatient, String? name, String? lastName, String secondLastName, DateTime? birthDate, String? ci, int? userId) async {
    try{
      if(idPatient != null && name != null && lastName != null  && birthDate != null && ci != null && userId != null){
        await apiServicePatient.updatePatient(idPatient, name, lastName, secondLastName, birthDate, ci, userId);

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

  Future<void> createNewPatient(String? name, String? lastName, String? secondLastName, DateTime? birthDate, String? ci, int? userId) async {
    try {
      if(name != null && lastName != null && birthDate != null && ci != null && userId != null){

        await apiServicePatient.createPatient(name, lastName, secondLastName!, birthDate, ci, userId);

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
