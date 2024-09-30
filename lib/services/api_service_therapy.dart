import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ps3_drops_v1/models/therapy.dart';

class ApiServiceTherapy {
  Future<List<Therapy>> fetchTherapies() async {
    try{
      String jsonContent = await rootBundle.loadString('../assets/data/therapy.json');
      if(kDebugMode){
        print('Contenido JSON: $jsonContent');
      }
      List<dynamic> jsonResponse = json.decode(jsonContent);
      return jsonResponse.map((data) => Therapy.fromJson(data)).toList();

    } catch (e){
      if (kDebugMode) {
        print('Error al cargar los datos: $e');
      }
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<List<Map<String, dynamic>>> loadTherapyData() async {
    String jsonString = await rootBundle.loadString('../assets/data/therapy.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(jsonData);
  }

  Future<int> getTotalTherapyRecords() async {
    List<Map<String, dynamic>> data = await loadTherapyData();
    return data.length;
  }
}