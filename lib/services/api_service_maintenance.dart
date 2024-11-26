import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:ps3_drops_v1/models/maintenance.dart';
import 'package:ps3_drops_v1/services/api_headers.dart';
import 'package:ps3_drops_v1/services/api_middleware.dart';
import 'package:ps3_drops_v1/tools/base_url_service.dart';

class ApiServiceMaintenance {
  final ApiMiddleware _apiMiddleware;
  ApiServiceMaintenance(this._apiMiddleware);

  Future<Maintenance> fetchBalanceIdByCode(BuildContext context,String balaceCode) async {
    try {
       final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/maintenance/getBalance/$balaceCode'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

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

  Future<Maintenance> registerMaintenance(BuildContext context ,Maintenance newMaintenance) async {
    try {
       final response = await _apiMiddleware.makeRequest(
        context,
        () => http.post(
          Uri.parse('${BaseUrlService.baseUrl}/maintenance/create'),
          headers: ApiHeaders.instance.buildHeaders(),
          body: jsonEncode(newMaintenance.toJsonInsert()),
        ),
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