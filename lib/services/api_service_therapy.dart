import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ps3_drops_v1/models/therapy.dart';

class ApiServiceTherapy {
  final String baseUrl = 'http://127.0.0.1:5000/api/v1';

  Future<List<Therapy>> fetchTherapies() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/therapies'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        return jsonResponse.map((data) => Therapy.fromJson(data)).toList();

        
      } else {
        throw Exception('Error al obtener los registros de Terapias: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar los datos: $e');
      }
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<List<Patient>> fetchTherapyPatients() async {
    try{
      final response = await http.get(Uri.parse('$baseUrl/therapy/patients'));

      if(response.statusCode == 200){
        List<dynamic> jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        return jsonResponse.map((data) => Patient.fromJson(data)).toList();
      } else {
        throw Exception('Error: Fallo al cargar los Datos. Codigo de Estado: ${response.statusCode}');
      }
    } catch (e) {
      if(kDebugMode){
        print('Error: Fallo al cargar los Datos.');
      }
      throw Exception('Error: Fallo al cargar los datos: $e');
    }
  }

  Future<List<Nurse>> fetchTherapyNurses() async {
    try{
      final response = await http.get(Uri.parse('$baseUrl/therapy/nurses'));

      if(response.statusCode == 200){
        List<dynamic> jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        return jsonResponse.map((data) => Nurse.fromJson(data)).toList();
      } else {
        throw Exception('Error: Fallo al cargar los Datos. Codigo de Estado: ${response.statusCode}');
      }
    } catch (e) {
      if(kDebugMode){
        print('Error: Fallo al cargar los Datos.');
      }
      throw Exception('Error: Fallo al cargar los datos: $e');
    }
  }

  Future<List<Balance>> fetchTherapyBalances() async {
    try{
      final response = await http.get(Uri.parse('$baseUrl/therapy/balances'));

      if(response.statusCode == 200){
        List<dynamic> jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        return jsonResponse.map((data) => Balance.fromJson(data)).toList();
      } else {
        throw Exception('Error: Fallo al cargar los Datos. Codigo de Estado: ${response.statusCode}');
      }
    } catch (e) {
      if(kDebugMode){
        print('Error: Fallo al cargar los Datos.');
      }
      throw Exception('Error: Fallo al cargar los datos: $e');
    }
  }

  Future<InfoTherapy> fetchInfoTherapy(int therapyId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/therapy/info/$therapyId'));

      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        return InfoTherapy.fromJson(jsonResponse);
      } else {
        throw Exception('Error: Fallo al cargar los datos. Código de Estado: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al recuperar la información.");
      }
      throw Exception("Error: Fallo al recuperar la Información de la Terapia: $e");
    }
  }

  Future<Therapy> createTherapy(int patientId, int nurseId, int balanceId, String stretcherNumber, int userId) async {
    try {
      final body = jsonEncode({
        'stretcher_number': stretcherNumber,
        'id_balance': balanceId,
        'id_patient': patientId,
        'id_nurse': nurseId,
        'id_user': userId,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/therapy/create'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Therapy.fromJson(jsonResponse);
      } else {
        throw Exception("Error al crear la terapia: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al crear la Terapia. Detalles: $e");
      }
      throw Exception("Error: Fallo al crear la Terapia.");
    }
  }
}
