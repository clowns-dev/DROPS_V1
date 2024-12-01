import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/patient.dart';
import 'package:ps3_drops_v1/services/api_service_patient.dart';
import 'package:ps3_drops_v1/services/api_middleware.dart';

class PatientViewModel extends ChangeNotifier {
  final ApiMiddleware _apiMiddleware = ApiMiddleware();
  late final ApiServicePatient _apiServicePatient = ApiServicePatient(_apiMiddleware);

  List<Patient> listPatients = [];
  List<Patient> filteredPatients = [];
  Patient? patient;

  bool isLoading = false;
  bool hasMatches = true;

  PatientViewModel();

  Future<void> fetchPatients(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      listPatients = await _apiServicePatient.fetchPatients(context);
      filteredPatients = List.from(listPatients);
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener los registros de Pacientes: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Patient?> fetchPatientById(BuildContext context, int id) async {
    isLoading = true;
    notifyListeners();
    try {
      patient = await _apiServicePatient.fetchPatientById(context, id);
    } catch (e) {
      if (kDebugMode) {
        print("Error al obtener el registro del Paciente.");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return patient;
  }

  Future<bool> isCiRegistered(BuildContext context, String ci) async {
    try {
      return await _apiServicePatient.verifyExistPatient(context, ci);
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

  Future<void> editPatient(BuildContext context, Patient updatePatient) async {
    try {
      if (updatePatient.idPatient != null &&
          // ignore: unnecessary_null_comparison
          updatePatient.name != null &&
          // ignore: unnecessary_null_comparison
          updatePatient.lastName != null &&
          updatePatient.birthDate != null &&
          // ignore: unnecessary_null_comparison
          updatePatient.ci != null &&
          updatePatient.userID != null) {
        await _apiServicePatient.updatePatient(context, updatePatient);
      } else {
        if (kDebugMode) {
          print("Error: Faltan datos para la Edición.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: No se pudo actualizar al Paciente.\n Detalles: $e");
      }
    }
  }

  Future<void> removePatient(BuildContext context, int? idPatient, int? userId) async {
    try {
      if (idPatient != null && userId != null) {
        final response = await _apiServicePatient.deletePatient(context, idPatient, userId);

        if (kDebugMode) {
          print("$response");
        }
      } else {
        if (kDebugMode) {
          print("Error: Faltan datos para la eliminación. idPatient o userId es null.");
        }
        throw Exception("Datos incompletos para la eliminación.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: No se pudo eliminar al Paciente. Detalles: $e");
      }
    }
  }


  Future<void> createNewPatient(BuildContext context, Patient newPatient) async {
    try {
      if (newPatient.birthDate != null &&
          newPatient.userID != null) {
        await _apiServicePatient.createPatient(context, newPatient);

        if (kDebugMode) {
          print("Paciente Creado Exitosamente!");
        }
      } else {
        if (kDebugMode) {
          print("Error: Faltan datos para la Creación.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: No se pudo crear al Paciente.\n Detalles: $e");
      }
    }
  }
}
