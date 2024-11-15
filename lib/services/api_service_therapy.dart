import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ps3_drops_v1/models/patient.dart' as PatientModel;
import 'package:ps3_drops_v1/models/nurse.dart' as NurseModel;
import 'package:ps3_drops_v1/models/balance.dart' as BalanceModel;
import 'package:ps3_drops_v1/models/therapy.dart' as TherapyModel;

class ApiServiceTherapy {
  Future<List<TherapyModel.Therapy>> fetchTherapies() async {
    try {
      String jsonContent =
          await rootBundle.loadString('assets/data/therapy.json');
      List<dynamic> jsonResponse = json.decode(jsonContent);
      print("Datos de Terapias: $jsonResponse");
      return jsonResponse
          .map((data) => TherapyModel.Therapy.fromJson(data))
          .toList();
    } catch (e) {
      print("Error al cargar los datos de terapias: $e");
      throw Exception('Error al cargar los datos de terapias: $e');
    }
  }

  Future<List<PatientModel.Patient>> fetchTherapyPatients() async {
    try {
      String jsonContent =
          await rootBundle.loadString('assets/data/patient.json');
      List<dynamic> jsonResponse = json.decode(jsonContent);
      return jsonResponse
          .map((data) => PatientModel.Patient.fromJson(data))
          .toList();
    } catch (e) {
      print('Error al cargar los datos de pacientes: $e');
      throw Exception('Error al cargar los datos de pacientes: $e');
    }
  }

  Future<List<NurseModel.Nurse>> fetchTherapyNurses() async {
    try {
      String jsonContent =
          await rootBundle.loadString('assets/data/nurse.json');
      List<dynamic> jsonResponse = json.decode(jsonContent);
      return jsonResponse
          .map((data) => NurseModel.Nurse.fromJson(data))
          .toList();
    } catch (e) {
      print('Error al cargar los datos de enfermeros: $e');
      throw Exception('Error al cargar los datos de enfermeros: $e');
    }
  }

  Future<List<BalanceModel.Balance>> fetchTherapyBalances() async {
    try {
      String jsonContent =
          await rootBundle.loadString('assets/data/balance.json');
      List<dynamic> jsonResponse = json.decode(jsonContent);
      print("Datos de Balanzas: $jsonResponse");
      return jsonResponse
          .map((data) => BalanceModel.Balance.fromJson(data))
          .toList();
    } catch (e) {
      print('Error al cargar los datos de balanzas: $e');
      throw Exception('Error al cargar los datos de balanzas: $e');
    }
  }

  Future<TherapyModel.InfoTherapy> fetchInfoTherapy(int therapyId) async {
    try {
      String jsonContent =
          await rootBundle.loadString('assets/data/therapy_info.json');
      List<dynamic> jsonResponse = json.decode(jsonContent);
      var therapyData =
          jsonResponse.firstWhere((data) => data['idTherapy'] == therapyId);
      return TherapyModel.InfoTherapy.fromJson(therapyData);
    } catch (e) {
      print("Error al cargar la información de terapia: $e");
      throw Exception("Error al cargar la información de terapia: $e");
    }
  }

  Future<void> createTherapy(int patientId, int nurseId, int balanceId,
      String stretcherNumber, int userId) async {
    try {
      print("Simulando la creación de terapia...");
    } catch (e) {
      print("Error al simular la creación de la terapia: $e");
      throw Exception("Error al simular la creación de la terapia.");
    }
  }
}
