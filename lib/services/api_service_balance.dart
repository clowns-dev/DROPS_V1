import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ps3_drops_v1/models/balance.dart';
import 'package:ps3_drops_v1/services/api_headers.dart';
import 'package:ps3_drops_v1/services/api_middleware.dart';
import 'package:ps3_drops_v1/tools/base_url_service.dart';

class ApiServiceBalance {
  final ApiMiddleware _apiMiddleware;
  ApiServiceBalance(this._apiMiddleware);

  Future<List<Balance>> fetchBalances(BuildContext context) async { 
    try {
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/balances'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Balance.fromJson(data)).toList();
      } else {
        throw Exception('Error al obtener los registros de Balanzas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<Balance> fetchBalanceById(BuildContext context,int id) async { 
    try {
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/balance/byId/$id'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );
      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        return Balance.fromJson(jsonResponse);
      } else {
        throw Exception('Error al obtener el registro de la Balanza: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<bool> verifyExistBalance(BuildContext context, String code) async {
    try {
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/balance/checkExist/$code'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['balance_code'] != null && jsonResponse['balance_code'].isNotEmpty) {
          return true; 
        }
      }
      return false;
    } catch (e) {
      throw Exception('Error al verificar existencia.');
    }
  } 

  Future<Balance> createBalance(BuildContext context, Balance newBalance) async {
    try {
      final body = jsonEncode({
        'balance_code': newBalance.balanceCode,
        'user_id': newBalance.userID,
      });
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.post(
          Uri.parse('${BaseUrlService.baseUrl}/balance/create'),
          headers: ApiHeaders.instance.buildHeaders(),
          body: body,
        ),
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Balance.fromJson(jsonResponse);
      } else {
        throw Exception("Error al crear la balanza: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: Fallo al crear la Balanza.");
    }
  }

  Future<Balance> updateBalance(BuildContext context, Balance modifyBalance) async {
    try {
      final body = jsonEncode({
        'balance_id': modifyBalance.idBalance,
        'balance_code': modifyBalance.balanceCode,
        'user_id': modifyBalance.userID,
      });
      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.put(
          Uri.parse('${BaseUrlService.baseUrl}/balance/update'),
          headers: ApiHeaders.instance.buildHeaders(),
          body: body,
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Balance.fromJson(jsonResponse);
      } else {
        throw Exception("Error al actualizar la balanza: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: Fallo al actualizar la Balanza.");
    }
  }

  Future<Balance> deleteBalance(BuildContext context ,int idBalance, int userId) async {
    try {
      if(kDebugMode){
        print("Balanza a eliminar: $idBalance");
      }

      final body = jsonEncode({
        'balance_id': idBalance,
        'user_id': userId,
      });

      final response = await _apiMiddleware.makeRequest(
        context,
        () => http.delete(
          Uri.parse('${BaseUrlService.baseUrl}/balance/delete'),
          headers: ApiHeaders.instance.buildHeaders(),
          body: body,
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Balance.fromJson(jsonResponse);
      } else {
        throw Exception("Error al eliminar la balanza: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: Fallo al eliminar la Balanza.");
    }
  }
}