import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ps3_drops_v1/models/smart.dart';

class ApiServiceSmart {
  Future<List<Smart>> fetchSmarts() async{
    try{
      String jsonContent = await rootBundle.loadString('../assets/data/smart.json');
      if(kDebugMode){
        print('Contenido JSON: $jsonContent');
      }
      List<dynamic> jsonResponse = json.decode(jsonContent);
      return jsonResponse.map((data) => Smart.fromJson(data)).toList();

    } catch (e){
      if(kDebugMode){
        print("Error al cargar los datos: $e");
      }
      throw Exception('Error al cargar los datos: $e');
    }
  }
}