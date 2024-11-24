import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:ps3_drops_v1/models/maintenance.dart';

class ApiServiceMaintenance {
  final String baseUrl = 'http://127.0.0.1:5000/api/v1';

  Future<Maintenance> fetchBalanceIdByCode(String balaceCode) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/maintenance/getBalance/$balaceCode'));

      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        return Maintenance.fromJson(jsonResponse);
      } else {
        throw Exception('Error al obtener el registro de la Balanza: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar los datos: $e');
      }
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<Maintenance> registerMaintenance(Maintenance newMaintenance) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/maintenance/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newMaintenance.toJsonInsert()),
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Maintenance.fromJson(jsonResponse);
      } else {
        throw Exception("Error al registrar el mantenimiento: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al registrar el mantenimiento. Detalles: $e");
      }
      throw Exception("Error: Fallo al registrar el mantenimiento.");
    }
  }
}