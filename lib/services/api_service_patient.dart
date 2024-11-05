import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/patient.dart';

class ApiServicePatient {
  final String baseUrl = 'http://127.0.0.1:5000/api/v1';

  Future<List<Patient>> fetchPatients() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/patients'));
      
      if(response.statusCode == 200){
        List<dynamic> jsonResponse = json.decode(response.body);
  
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        return jsonResponse.map((data) => Patient.fromJson(data)).toList();
      } else {
        throw Exception('Error al obtener los registros de Pacientes: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar los datos: $e');
      }
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<Patient> fetchPatientById(int id) async { 
    try {
      final response = await http.get(Uri.parse('$baseUrl/patient/byId/$id'));

      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        return Patient.fromJson(jsonResponse);
      } else {
        throw Exception('Error al obtener el registro del Patient: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar los datos: $e');
      }
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<Patient> updatePatient(int idPatient, String name, String lastName, String secondLastName,DateTime birthDate, String ci, int userId) async {
    try {
      String formattedBirthDate = DateFormat('yyyy-MM-dd').format(birthDate);

      final body = jsonEncode({
        'patient_id': idPatient,
        'name': name,
        'last_name': lastName,
        'second_last_name': secondLastName.isEmpty ? null : secondLastName,
        'birth_date': formattedBirthDate,
        'ci': ci,
        'user_id': userId,
      });

      final response = await http.put(
        Uri.parse('$baseUrl/patient/update'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Patient.fromJson(jsonResponse);
      } else {
        throw Exception("Error al actualizar al Paciente: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al actualizar el Paciente. Detalles: $e");
      }
      throw Exception("Error: Fallo al actualizar al Paciente.");
    }
  }

  Future<Patient> deletePatient(int idPatient, int userId) async {
    try {
      final body = jsonEncode({
        'patient_id': idPatient,
        'user_id': userId,
      });

      final response = await http.put(
        Uri.parse('$baseUrl/patient/delete'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Patient.fromJson(jsonResponse);
      } else {
        throw Exception("Error al eliminar al Paciente: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al eliminar al Paciente. Detalles: $e");
      }
      throw Exception("Error: Fallo al eliminar al Paciente.");
    }
  }

  Future<Patient> createPatient(String name, String lastName, String secondLastName,DateTime birthDate, String ci, int userId) async {
    try {
      String formattedBirthDate = DateFormat('yyyy-MM-dd').format(birthDate);
      final body = jsonEncode({
        'name': name,
        'last_name': lastName,
        'second_last_name': secondLastName.isEmpty ? null : secondLastName,
        'birth_date': formattedBirthDate,
        'ci': ci,
        'user_id': userId,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/patient/create'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Patient.fromJson(jsonResponse);
      } else {
        throw Exception("Error al crear al Paciente: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al crear al Paciente. Detalles: $e");
      }
      throw Exception("Error: Fallo al crear al Paciente.");
    }
  }
}
