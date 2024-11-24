import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/user.dart';
import 'package:ps3_drops_v1/services/api_service_user.dart';
import 'package:ps3_drops_v1/services/api_middleware.dart';

class UserViewModel extends ChangeNotifier {
  final ApiMiddleware _apiMiddleware = ApiMiddleware();
  late final ApiServiceUser apiServiceUser = ApiServiceUser(_apiMiddleware);
  User? user;
  List<User> listUsers = [];  
  List<User> filteredUsers = []; 
  bool isLoading = false;
  bool hasMatches = true;

  UserViewModel();
   

  Future<void> fetchUsers(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    
    try {
      listUsers = await apiServiceUser.fetchUsers(context);
      filteredUsers = List.from(listUsers); 
      hasMatches = filteredUsers.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener los registros de Usuarios: $e');
      }
    } finally {
      isLoading = false;  
      notifyListeners();
    }
  }


  void filterUsers(String query, String field) {
    if (query.isEmpty || field == 'Buscar por:') {
      filteredUsers = List.from(listUsers);
    } else {
      switch (field) {
        case 'CI':
          filteredUsers = listUsers
              .where((user) => user.ci?.toLowerCase().contains(query.toLowerCase()) ?? false)
              .toList();
          break;
        case 'Nombre':
          filteredUsers = listUsers
              .where((user) => user.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
              .toList();
          break;
        case 'Apellido':
          filteredUsers = listUsers
              .where((user) => user.lastName?.toLowerCase().contains(query.toLowerCase()) ?? false)
              .toList();
          break;
        default:
          filteredUsers = List.from(listUsers);
      }
    }
    hasMatches = filteredUsers.isNotEmpty;
    notifyListeners();
  }




  Future<User?> fetchUserById(BuildContext context,int id) async {
    isLoading = true;
    User? user;
    try {
      user = await apiServiceUser.fetchUserById(context, id); 
      if (kDebugMode) {
        print('Usuario cargado: ${user.idUser}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener el registro del usuario: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return user;
  }

  Future<bool> isCiRegistered(BuildContext context,String ci) async {
    try {
      return await apiServiceUser.verifyExistUser(context, ci);
    } catch (e) {
      if (kDebugMode) {
        print('Error al verificar si el CI está registrado: $e');
      }
      return false;
    }
  }


  Future<void> createNewUser(BuildContext context, User? newUser) async {
    try {
      if(newUser != null){
        await apiServiceUser.createUser(context, newUser);

        if(kDebugMode){
          print("Usuario creada Exitosamente!");
        } else {
          if(kDebugMode){
            print("Error: Faltan datos para la creacion.");
          }
        }
      }
    } catch (e){
      if (kDebugMode){
        print("Error: No se pudo crear la Usuario.\n Detalles: $e");
      }
    }
  }

  Future<void> editUser(BuildContext context, User? modifyUser) async {
    try {
      if (modifyUser != null) {
          
        await apiServiceUser.updateUser(context, modifyUser);
        if (kDebugMode) {
          print("Usuario Editada Exitosamente!");
        }
        
      } else {
        if (kDebugMode) {
          print("Error: Faltan datos para la Edición.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: No se pudo actualizar al Usuario.\nDetalles: $e");
      }
    }
  }

  Future<void> removeUser(BuildContext context, int? idUser) async {
    try {
      if(idUser != null && idUser > 0){
        await apiServiceUser.deleteUser(context, idUser);
        if(kDebugMode){
          print("Usuario Eliminada Exitosamente!");
        } else {
          if(kDebugMode){
            print("Error: Faltan datos para la eliminacion.");
          }
        }
      }
    } catch (e){
      if (kDebugMode){
        print("Error: No se pudo eliminar la Usuario.\n Detalles: $e");
      }
    }
  }
}
