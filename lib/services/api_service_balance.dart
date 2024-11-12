import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ps3_drops_v1/models/balance.dart';

class ApiServiceBalance {
  final String baseUrl = 'http://127.0.0.1:5000/api/v1';

  Future<List<Balance>> fetchBalances() async { 
    try {
      final response = await http.get(Uri.parse('$baseUrl/balances'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        return jsonResponse.map((data) => Balance.fromJson(data)).toList();
      } else {
        throw Exception('Error al obtener los registros de Balanzas: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar los datos: $e');
      }
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<Balance> fetchBalanceById(int id) async { 
    try {
      final response = await http.get(Uri.parse('$baseUrl/balance/byId/$id'));

      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        return Balance.fromJson(jsonResponse);
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

  Future<bool> verifyExistBalance(String code) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/balance/checkExist/$code'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        
        if (jsonResponse['balance_code'] != null && jsonResponse['balance_code'].isNotEmpty) {
          return true; 
        }
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error al verificar existencia.');
      }
      throw Exception('Error al verificar existencia.');
    }
  } 

  Future<Balance> createBalance(Balance newBalance) async {
    try {
      final body = jsonEncode({
        'balance_code': newBalance.balanceCode,
        'user_id': newBalance.userID,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/balance/create'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Balance.fromJson(jsonResponse);
      } else {
        throw Exception("Error al crear la balanza: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al crear la Balanza. Detalles: $e");
      }
      throw Exception("Error: Fallo al crear la Balanza.");
    }
  }

  Future<Balance> updateBalance(Balance modifyBalance) async {
    try {
      final body = jsonEncode({
        'balance_id': modifyBalance.idBalance,
        'balance_code': modifyBalance.balanceCode,
        'user_id': modifyBalance.userID,
      });

      final response = await http.put(
        Uri.parse('$baseUrl/balance/update'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Balance.fromJson(jsonResponse);
      } else {
        throw Exception("Error al actualizar la balanza: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al actualizar la Balanza. Detalles: $e");
      }
      throw Exception("Error: Fallo al actualizar la Balanza.");
    }
  }

  Future<Balance> deleteBalance(int idBalance, int userId) async {
    try {
      if(kDebugMode){
        print("Balanza a eliminar: $idBalance");
      }

      final body = jsonEncode({
        'balance_id': idBalance,
        'user_id': userId,
      });

      final response = await http.delete(
        Uri.parse('$baseUrl/balance/delete'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Balance.fromJson(jsonResponse);
      } else {
        throw Exception("Error al eliminar la balanza: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al eliminar la Balanza. Detalles: $e");
      }
      throw Exception("Error: Fallo al eliminar la Balanza.");
    }
  }
}