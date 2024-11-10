import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/user.dart';

class ApiServiceUser {
  final String baseUrl = 'http://127.0.0.1:5000/api/v1';

  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));
      
      if(response.statusCode == 200){
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => User.fromJson(data)).toList();
      } else {
        throw Exception('Error al obtener los registros de Usuarios: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar los datos: $e');
      }
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<User> fetchUserById(int id) async { 
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/byId/$id'));

      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        return User.fromJson(jsonResponse);
      } else {
        throw Exception('Error al obtener el registro del Usuario: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar los datos: $e');
      }
      throw Exception('Error al cargar los datos: $e');
    }
  }

  Future<bool> verifyExistUser(String ci) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/checkExist/$ci'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print('Contenido JSON: $jsonResponse');
        }
        
        if (jsonResponse['ci'] != null && jsonResponse['ci'].isNotEmpty) {
          return true; // El usuario existe
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



  Future<User> createUser(User newUser) async {
    try {
      String formattedBirthDate = DateFormat('yyyy-MM-dd').format(newUser.birthDate!);

      final body = jsonEncode({
        'name': newUser.name,
        'last_name': newUser.lastName,
        'second_last_name': newUser.secondLastName,
        'phone': newUser.phone,
        'email': newUser.email,
        'address': newUser.address,
        'birth_date': formattedBirthDate,
        'genre': newUser.genre,
        'ci': newUser.ci,
        'role_id': newUser.idRole
      });




      final response = await http.post(
        Uri.parse('$baseUrl/user/create'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
   

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return User.fromJson(jsonResponse);
      } else {
        throw Exception("Error al crear al Usuario: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al crear al Usuario. Detalles: $e");
      }
      throw Exception("Error: Fallo al crear al Usuario.");
    }
  }

  Future<User> updateUser(User updateUser) async {
    try {
      String formattedBirthDate = DateFormat('yyyy-MM-dd').format(updateUser.birthDate!);

      final body = jsonEncode({
        'user_id': updateUser.idUser,
        'name': updateUser.name,
        'last_name': updateUser.lastName,
        'second_last_name': updateUser.secondLastName,
        'phone': updateUser.phone,
        'email': updateUser.email,
        'address': updateUser.address,
        'birth_date': formattedBirthDate,
        'genre': updateUser.genre,
        'ci': updateUser.ci,
        'role_id': updateUser.idRole
      });

      final response = await http.put(
        Uri.parse('$baseUrl/user/update'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return User.fromJson(jsonResponse);
      } else {
        throw Exception("Error al actualizar al Usuario: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al actualizar al usuario. Detalles: $e");
      }
      throw Exception("Error: Fallo al actualizar al usuario.");
    }
  }

  Future<User> deleteUser(int idUser) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/user/delete/$idUser'));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return User.fromJson(jsonResponse);
      } else {
        throw Exception("Error al eliminar al usuario: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: Fallo al eliminar al usuario. Detalles: $e");
      }
      throw Exception("Error: Fallo al eliminar al Usuario.");
    }
  }
}
