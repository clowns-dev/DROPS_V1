import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ps3_drops_v1/services/api_headers.dart';
import 'package:ps3_drops_v1/services/api_middleware.dart';
import 'package:ps3_drops_v1/tools/base_url_service.dart';
import '../models/user.dart';

class ApiServiceUser {
  final ApiMiddleware _apiMiddleware;
  ApiServiceUser(this._apiMiddleware);

  Future<List<User>> fetchUsers(BuildContext context) async {
    try {
      final response = await _apiMiddleware.makeRequest(
        context, 
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/users'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );
      
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

  Future<User> fetchUserById(BuildContext context,int id) async { 
    try {
      final response = await _apiMiddleware.makeRequest(
        context, 
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/user/byId/$id'),
          headers: ApiHeaders.instance.buildHeaders(),
        ),
      );

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

  Future<bool> verifyExistUser(BuildContext context,String ci) async {
    try {
      final response = await _apiMiddleware.makeRequest(
        context, 
        () => http.get(
          Uri.parse('${BaseUrlService.baseUrl}/user/checkExist/$ci'),
          headers: ApiHeaders.instance.buildHeaders(), 
        )
      );
      
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

  Future<User> createUser(BuildContext context, newUser) async {
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

      final response = await _apiMiddleware.makeRequest(
        context, 
        () => http.post(
          Uri.parse('${BaseUrlService.baseUrl}/user/create'),
          headers: ApiHeaders.instance.buildHeaders(), 
          body: body
        )
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

  Future<User> updateUser(BuildContext context, updateUser) async {
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

      final response = await _apiMiddleware.makeRequest(
        context, 
        () => http.put(
          Uri.parse('${BaseUrlService.baseUrl}/user/update'),
          headers: ApiHeaders.instance.buildHeaders(), 
          body: body
        )
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

  Future<User> deleteUser(BuildContext context, idUser) async {
    try {
      final response = await _apiMiddleware.makeRequest(
        context, 
        () => http.delete(
          Uri.parse('${BaseUrlService.baseUrl}/user/delete/$idUser'),
          headers: ApiHeaders.instance.buildHeaders(), 
        )
      );


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
