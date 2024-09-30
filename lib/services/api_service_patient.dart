import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/patient.dart';

class ApiServicePatient {
  Future<List<Patient>> fetchPatients() async {
    try {
      // Cargar el archivo JSON desde los assets
      String jsonContent = await rootBundle.loadString('../assets/data/patient.json');
      
      // Verificar el contenido del archivo JSON
      if (kDebugMode) {
        print('Contenido JSON: $jsonContent');
      }

      // Decodificar el JSON y convertirlo a una lista de objetos Patient
      List<dynamic> jsonResponse = json.decode(jsonContent);
      return jsonResponse.map((data) => Patient.fromJson(data)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar los datos: $e');
      }
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<List<Map<String, dynamic>>> loadPatientData() async {
    String jsonString = await rootBundle.loadString('../assets/data/patient.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(jsonData);
  }

  Future<int> getTotalPatientRecords() async {
    List<Map<String, dynamic>> data = await loadPatientData();
    return data.length;
  }
}
