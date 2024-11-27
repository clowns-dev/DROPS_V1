import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/services/api_headers.dart';
import 'package:ps3_drops_v1/services/api_middleware.dart';
import 'package:ps3_drops_v1/tools/base_url_service.dart';

class ApiServiceTherapy {
  final ApiMiddleware _apiMiddleware;
  ApiServiceTherapy(this._apiMiddleware);

  Future<List<Therapy>> fetchTherapies(BuildContext context) async {
    try {
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/therapies'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
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

  Future<List<Patient>> fetchTherapyPatients(BuildContext context) async {
    try{
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/therapy/patients'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

      if(response.statusCode == 200){
        List<dynamic> jsonResponse = json.decode(response.body);
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

  Future<List<Nurse>> fetchTherapyNurses(BuildContext context) async {
    try{
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/therapy/nurses'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

      if(response.statusCode == 200){
        List<dynamic> jsonResponse = json.decode(response.body);
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

  Future<List<Balance>> fetchTherapyBalances(BuildContext context) async {
    try{
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/therapy/balances'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

      if(response.statusCode == 200){
        List<dynamic> jsonResponse = json.decode(response.body);
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

  Future<InfoTherapy> fetchInfoTherapy(BuildContext context, int therapyId) async {
    try {
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/therapy/info/$therapyId'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        
        return InfoTherapy.fromJson(jsonResponse);
      } else {
        throw Exception('Error: Fallo al cargar los datos. Código de Estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error: Fallo al recuperar la Información de la Terapia: $e");
    }
  }

  Future<List<InfoTherapiesNurse>> fetchInfoNurseTherapies(BuildContext context, int idNurse) async {
    try{
      final response = await _apiMiddleware.makeRequest(
        context, 
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/therapies/nurses/$idNurse'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

      if(response.statusCode == 200){
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((data) => InfoTherapiesNurse.fromJson(data)).toList();
      } else {
        throw Exception("Error: Fallo interno del servidor");
      }
    } catch (e) {
      throw Exception("Error: Fallo al recuperar la Información de la Terapia: $e");
    }
  }

  Future<List<InfoTherapiesNurse>> fetchInfoAssignmentTherapies(BuildContext context) async {
    try{
      final response = await _apiMiddleware.makeRequest(
        context, 
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/therapies/asign'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

      if(response.statusCode == 200){
        List<dynamic> jsonResponse = jsonDecode(response.body);
        if(kDebugMode){
          print('datos: $jsonResponse');
        }
        return jsonResponse.map((data) => InfoTherapiesNurse.fromJson(data)).toList();
      } else {
        throw Exception("Error: Fallo interno del servidor");
      }
    } catch (e) {
      throw Exception("Error: Fallo al recuperar la Información de la Terapia: $e");
    }
  }

  Future<Therapy> createTherapy(BuildContext context, insertTherapy) async {
    try {
      final body = jsonEncode({
        'stretcher_number': insertTherapy.stretcherNumber,
        'balance_id': insertTherapy.idBalance,
        'patient_id': insertTherapy.idPerson,
        'nurse_id': insertTherapy.idNurse,
        'user_id': insertTherapy.userID,
      });

      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.post(
          Uri.parse('${BaseUrlService.baseUrl}/therapy/create'),
          headers: ApiHeaders.instance.buildHeaders(),
          body: body
        ),
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

  Future<void> insertSampleDate(BuildContext context, int idTherapy,int idBalance, double percentage, int alert) async {
    try{
      final body = jsonEncode({
        'therapy_id': idTherapy,
        'balance_id': idBalance,
        'percentage': percentage,
        'alert': alert,
      });

      final response = await _apiMiddleware.makeRequest(
        context, 
        () => http.post(
          Uri.parse('${BaseUrlService.baseUrl}/therapy/sample'),
          headers: ApiHeaders.instance.buildHeaders(),
          body: body
        )
      );

      if(response.statusCode == 201){
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      }

    } catch (e){
       if (kDebugMode) {
        print("Error: Fallo al registrar los datos. Detalles: $e");
      }
      throw Exception("Error al registrar los datos");
    }
  }
}
