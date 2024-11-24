import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ps3_drops_v1/models/smart.dart';
import 'package:ps3_drops_v1/services/api_headers.dart';
import 'package:ps3_drops_v1/services/api_middleware.dart';
import 'package:ps3_drops_v1/tools/base_url_service.dart';

class ApiServiceSmart {
  final ApiMiddleware _apiMiddleware;
  ApiServiceSmart(this._apiMiddleware);

  Future<List<Smart>> fetchSmarts(BuildContext context) async {
    try {
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/smarts'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );
      if(response.statusCode == 200){
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((data) => Smart.fromJson(data)).toList();
      } else {
        throw Exception('Error al obtener los registros de las Manillas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<Smart> fetchSmartById(BuildContext context, int idSmart) async  {
    try{
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/smart/byId/$idSmart'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        return Smart.fromJson(jsonResponse);
      } else {
        throw Exception('Error al obtener el registro de la Balanza: ${response.statusCode}');
      }
    } catch (e){
      throw Exception('Fallo al recuperar el registro: $e');
    }
  }

  Future<Smart> assignmentSmart(BuildContext context, Smart asignSmart) async {
    try {
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.put(
          Uri.parse('${BaseUrlService.baseUrl}/smart/asign'),
          headers: ApiHeaders.instance.buildHeaders(),
          body: jsonEncode(asignSmart.toJsonAssignment()),
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Smart.fromJson(jsonResponse);
      } else {
        throw Exception("Error al asignar la manilla: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: Fallo al asignar la manilla.");
    }
  }

  Future<bool> verifyExistCodeRFID(BuildContext context, String codeRFID) async {
    try{
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/smart/checkExist/$codeRFID'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

      if(response.statusCode == 200){
        final jsonResponse = jsonDecode(response.body);
        if(jsonResponse['code_rfid'] != null && jsonResponse['code_rfid'].isNotEmpty){
          return true;
        }
      }
      return false;
    }catch (e){
      throw Exception('Error al verificar existencia.');
    }
  }

  Future<Smart> createSmart(BuildContext context, Smart createSmart) async {
    try {
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.post(
          Uri.parse('${BaseUrlService.baseUrl}/smart/create'),
          headers: ApiHeaders.instance.buildHeaders(),
          body: jsonEncode(createSmart.toJsonInsert()),
        ),
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Smart.fromJson(jsonResponse);
      } else {
        throw Exception("Error al crear la manilla: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: Fallo al crear la manilla.");
    }
  }

  Future<Smart> updateSmart(BuildContext context, Smart updateSmart) async {
    try {
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.put(
          Uri.parse('${BaseUrlService.baseUrl}/smart/update'),
          headers: ApiHeaders.instance.buildHeaders(),
          body: jsonEncode(updateSmart.toJsonUpdate()),
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Smart.fromJson(jsonResponse);
      } else {
        throw Exception("Error al actualizar la manilla: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: Fallo al actualizar la manilla.");
    }
  }

  Future<Smart> deleteSmart(BuildContext context, int idSmart) async {
    try{
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.delete(
          Uri.parse('${BaseUrlService.baseUrl}/smart/delete/$idSmart'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

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