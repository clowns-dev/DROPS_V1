import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ps3_drops_v1/services/api_headers.dart';
import 'package:ps3_drops_v1/tools/base_url_service.dart';
import 'package:ps3_drops_v1/services/api_middleware.dart';
import '../models/patient.dart';

class ApiServicePatient {
  final ApiMiddleware _apiMiddleware;
  ApiServicePatient(this._apiMiddleware);

  Future<List<Patient>> fetchPatients(BuildContext context) async {
    try {
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/patients'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Patient.fromJson(data)).toList();
      } else {
        throw Exception('Error al obtener los registros de Pacientes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<Patient> fetchPatientById(BuildContext context, int id) async {
    try {
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/patient/byId/$id'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        return Patient.fromJson(jsonResponse);
      } else {
        throw Exception('Error al obtener el registro del Patient: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<Patient> updatePatient(BuildContext context, Patient modifyPatient) async {
    try {
      String formattedBirthDate =
          DateFormat('yyyy-MM-dd').format(modifyPatient.birthDate!);

      final body = jsonEncode({
        'patient_id': modifyPatient.idPatient,
        'name': modifyPatient.name,
        'last_name': modifyPatient.lastName,
        'second_last_name': modifyPatient.secondLastName!.isEmpty ? "" : modifyPatient.secondLastName,
        'birth_date': formattedBirthDate,
        'ci': modifyPatient.ci,
        'genre': modifyPatient.genre,
        'user_id': modifyPatient.userID,
      });

      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.put(
          Uri.parse('${BaseUrlService.baseUrl}/patient/update'),
          headers: ApiHeaders.instance.buildHeaders(),
          body: body,
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Patient.fromJson(jsonResponse);
      } else {
        throw Exception("Error al actualizar al Paciente: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: Fallo al actualizar al Paciente. Detalles: $e");
    }
  }

  Future<bool> verifyExistPatient(BuildContext context, String ci) async {
    try {
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/patient/checkExist/$ci'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['ci'] != null && jsonResponse['ci'].isNotEmpty;
      }
      return false;
    } catch (e) {
      throw Exception('Error al verificar existencia: $e');
    }
  }

  Future<Patient> deletePatient(BuildContext context, int? idPatient, int? userId) async {
    try {

      Map<String, dynamic> toJsonUpdate() {
        return {
          'patient_id': idPatient?.toString(),
          'user_id': userId?.toString(),
        };
      }

      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.delete(
          Uri.parse('${BaseUrlService.baseUrl}/patient/delete'),
          headers: ApiHeaders.instance.buildHeaders(),
          body: jsonEncode(toJsonUpdate()),
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Patient.fromJson(jsonResponse);
      } else {
        throw Exception("Error al eliminar al Paciente: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: Fallo al eliminar al Paciente. Detalles: $e");
    }
  }

  Future<Patient> createPatient(BuildContext context, Patient insertPatient) async {
    try {
      String formattedBirthDate =
          DateFormat('yyyy-MM-dd').format(insertPatient.birthDate!);

      final body = jsonEncode({
        'name': insertPatient.name,
        'last_name': insertPatient.lastName,
        'second_last_name': insertPatient.secondLastName!.isEmpty ? "" : insertPatient.secondLastName,
        'birth_date': formattedBirthDate,
        'ci': insertPatient.ci,
        'genre': insertPatient.genre,
        'user_id': insertPatient.userID,
      });

      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.post(
          Uri.parse('${BaseUrlService.baseUrl}/patient/create'),
          headers: ApiHeaders.instance.buildHeaders(),
          body: body,
        ),
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Patient.fromJson(jsonResponse);
      } else {
        throw Exception("Error al crear al Paciente: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: Fallo al crear al Paciente. Detalles: $e");
    }
  }
}
