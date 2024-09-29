import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/employee.dart';

class ApiServiceEmployee {
  Future<List<Employee>> fetchEmployees() async {
    try {
      // Cargar el archivo JSON desde los assets
      String jsonContent = await rootBundle.loadString('../assets/data/employee.json');
      
      // Verificar el contenido del archivo JSON
      if (kDebugMode) {
        print('Contenido JSON: $jsonContent');
      }

      // Decodificar el JSON y convertirlo a una lista de objetos Patient
      List<dynamic> jsonResponse = json.decode(jsonContent);
      return jsonResponse.map((data) => Employee.fromJson(data)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar los datos empleados: $e');
      }
      throw Exception('Error al cargar los datos empleados: $e');
    }
  }
}
