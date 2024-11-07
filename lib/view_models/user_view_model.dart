import 'package:flutter/foundation.dart';
import 'package:ps3_drops_v1/models/user.dart';
import 'package:ps3_drops_v1/services/api_service_user.dart';

class UserViewModel extends ChangeNotifier {
  ApiServiceUser apiServiceUser = ApiServiceUser();
  User? user;
  List<User> listUsers = [];  
  List<User> filteredUsers = []; 
  bool isLoading = false;
  bool hasMatches = true;

  UserViewModel() {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();
    
    try {
      listUsers = await apiServiceUser.fetchUsers();
      filteredUsers = List.from(listUsers); 
      hasMatches = filteredUsers.isNotEmpty;

    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener los registros de Usuarios: $e');
      }
    } finally {
      isLoading = false;  // Asegúrate de que esto esté aquí
      notifyListeners();
    }
  }


  void filterUsers(String query, String field) {
    if (query.isEmpty || field == 'Buscar por:') {
      filteredUsers = List.from(listUsers);
    } else {
      // Filtramos según el campo seleccionado
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




  Future<User?> fetchUserById(int id) async {
    isLoading = true;
    User? user;
    try {
      user = await apiServiceUser.fetchUserById(id); 
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

  Future<void> createNewUser(User? newUser) async {
    try {
      if(newUser != null){
        await apiServiceUser.createUser(newUser);

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

  Future<void> editUser(User? modifyUser) async {
    try {
      if (modifyUser != null) {
          
        await apiServiceUser.updateUser(modifyUser);
        await fetchUsers(); // Actualiza la lista después de editar
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

  Future<void> removeUser(int? idUser) async {
    try {
      if(idUser != null && idUser > 0){
        await apiServiceUser.deleteUser(idUser);
        await fetchUsers();
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
