import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ps3_drops_v1/models/smart.dart';

class ApiServiceSmart {
  final String baseUrl = 'http://127.0.0.1:5000/api/v1';

  Future<List<Smart>> fetchSmarts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/smarts'));

      if(response.statusCode == 200){
        List<dynamic> jsonResponse = jsonDecode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        return jsonResponse.map((data) => Smart.fromJson(data)).toList();
      } else {
        throw Exception('Error al obtener los registros de las Manillas: ${response.statusCode}');
      }

    } catch (e) {
      if(kDebugMode){
        print('Error al cargar los datos: $e');
      }
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<Smart> fetchSmartById(int idSmart) async  {
    try{
      final response = await http.get(Uri.parse('$baseUrl/smart/byId/$idSmart'));
      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        return Smart.fromJson(jsonResponse);
      } else {
        throw Exception('Error al obtener el registro de la Balanza: ${response.statusCode}');
      }
    } catch (e){
      if (kDebugMode){
        print('Fallo al recuperar el registro: $e');
      }
      throw Exception('Fallo al recuperar el registro: $e');
    }
  }

  Future<Smart> assignmentSmart(Smart asignSmart) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/smart/asign'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(asignSmart.toJsonAssignment()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Smart.fromJson(jsonResponse);
      } else {
        throw Exception("Error al asignar la manilla: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al asignar la manilla. Detalles: $e");
      }
      throw Exception("Error: Fallo al asignar la manilla.");
    }
  }

  Future<bool> verifyExistCodeRFID(String codeRFID) async {
    try{
      final response = await http.get(Uri.parse('$baseUrl/smart/checkExist/$codeRFID'));
      if(response.statusCode == 200){
        final jsonResponse = jsonDecode(response.body);

        if(jsonResponse['code_rfid'] != null && jsonResponse['code_rfid'].isNotEmpty){
          return true;
        }
      }
      return false;
    }catch (e){
      if (kDebugMode) {
        print('Error al verificar existencia.');
      }
      throw Exception('Error al verificar existencia.');
    }
  }

  Future<Smart> createSmart(Smart createSmart) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/smart/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(createSmart.toJsonInsert()),
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Smart.fromJson(jsonResponse);
      } else {
        throw Exception("Error al crear la manilla: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al crear la manilla. Detalles: $e");
      }
      throw Exception("Error: Fallo al crear la manilla.");
    }
  }

  Future<Smart> updateSmart(Smart updateSmart) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/smart/update'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updateSmart.toJsonUpdate()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Smart.fromJson(jsonResponse);
      } else {
        throw Exception("Error al actualizar la manilla: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al actualizar la manilla. Detalles: $e");
      }
      throw Exception("Error: Fallo al actualizar la manilla.");
    }
  }

  Future<Smart> deleteSmart(int idSmart) async {
    try{
      final response = await http.delete(Uri.parse('$baseUrl/smart/delete/$idSmart'));
      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        return Smart.fromJson(jsonResponse);
      } else {
        throw Exception('Error al eliminar el registro de la manilla: ${response.statusCode}');
      }
    } catch (e){
      if (kDebugMode){
        print('Fallo al eliminar el registro: $e');
      }
      throw Exception('Fallo al eliminar el registro: $e');
    }
  }
}