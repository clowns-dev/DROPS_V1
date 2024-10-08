import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ps3_drops_v1/models/balance.dart';

class ApiServiceBalance {
  Future<List<Balance>> fetchBalances() async{
    try{
      String jsonContent = await rootBundle.loadString('../assets/data/balance.json');

      if (kDebugMode) {
        print('Contenido JSON: $jsonContent');
      }
      List<dynamic> jsonResponse = json.decode(jsonContent);
      return jsonResponse.map((data) => Balance.fromJson(data)).toList();

    } catch (e){
      if (kDebugMode) {
        print('Error al cargar los datos de balanzas: $e');
      }
      throw Exception('Error al cargar los datos de balanzas: $e');
    }
  }

  Future<List<Map<String, dynamic>>> loadBalanceData() async {
    String jsonString = await rootBundle.loadString('../assets/data/balance.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(jsonData);
  }

  Future<int> getTotalBalanceRecords() async {
    List<Map<String, dynamic>> data = await loadBalanceData();
    return data.length;
  }
}