import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/smart.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/services/api_middleware.dart';
import 'package:ps3_drops_v1/services/api_service_smart.dart';

class SmartViewModel extends ChangeNotifier {
  final ApiMiddleware _apiMiddleware = ApiMiddleware();
  late final ApiServiceSmart apiServiceSmart = ApiServiceSmart(_apiMiddleware);
  Smart? smart;
  List<Smart> listSmarts = []; 
  List<Smart> filteredSmarts = []; 
   List<Nurse> listNursesWithoutSmarts = [];
  List<Nurse> filteredNursesWhithoutSmarts = [];
  bool isLoading = false;
  bool hasMatches = true;
  bool hastMatchesNurses = true;
   int? selectedNurseId; 

  SmartViewModel();
 
  Future<void> fetchSmarts(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    
    try {
      listSmarts = await apiServiceSmart.fetchSmarts(context);
      filteredSmarts = List.from(listSmarts); 
      hasMatches = filteredSmarts.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener los registros de Manillas: $e');
      }
    } finally {
      isLoading = false; 
      notifyListeners();
    }
  }
  

  Future<void> fetchSmartNurses(BuildContext context) async {
     isLoading = true;
    notifyListeners();
    try {
      listNursesWithoutSmarts = await apiServiceSmart.fetchSmartNurses(context);
      filteredNursesWhithoutSmarts = List.from(listNursesWithoutSmarts);
    } catch (e) {
      if (kDebugMode) {
        print('Error: Fallo al obtener los registros de Enfermeros.');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterNurses(String query) {
    if (query.isEmpty) {
      filteredNursesWhithoutSmarts = List.from(listNursesWithoutSmarts);
    } else {
      filteredNursesWhithoutSmarts = listNursesWithoutSmarts.where((nurse) {
        return nurse.fullName?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
    }
 
    hastMatchesNurses = filteredNursesWhithoutSmarts.isNotEmpty;
    notifyListeners();
  }

  void filterSmarts(String query, String field) {
    if (query.isEmpty || field == 'Buscar por:') {
      filteredSmarts = List.from(listSmarts);
    } else {
      switch (field) {
        case 'Codigo':
          filteredSmarts = listSmarts
              .where((smart) => smart.codeRFID?.toLowerCase().contains(query.toLowerCase()) ?? false)
              .toList();
          break;
        case 'Enfermero':
          filteredSmarts = listSmarts
              .where((smart) => smart.assingment?.toLowerCase().contains(query.toLowerCase()) ?? false)
              .toList();
          break;
        default:
          filteredSmarts = List.from(listSmarts);
      }
    }

    hasMatches = filteredSmarts.isNotEmpty;
    notifyListeners();
  }

  Future<Smart?> fetchBalanceById(BuildContext context, int id) async {
    isLoading = true;
    Smart? smart;
    try {
      smart = await apiServiceSmart.fetchSmartById(context, id); 
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener el registro de Balanza: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return smart;
  }

  Future<bool> isCodeRegistered(BuildContext context, String codeRFID) async {
    try{
      return await apiServiceSmart.verifyExistCodeRFID(context, codeRFID);
    }catch(e){
      if (kDebugMode) {
        print('Error al verificar si el codeRFID está registrado: $e');
      }
      return false;
    }
  }

  Future<void> createNewSmart(BuildContext context, Smart newSmart) async {
    try {
      if(newSmart.codeRFID != null){
        await apiServiceSmart.createSmart(context, newSmart); 
      }
    } catch (e){
      if (kDebugMode){
        print("Error: No se pudo crear la Manilla.\n Detalles: $e");
      }
    }
  }

  Future<void> editSmart(BuildContext context, Smart modifySmart) async {
    try {
      if (modifySmart.idSmart != null &&
          modifySmart.codeRFID != null &&
          modifySmart.available != null &&
          modifySmart.idUser != null) {
          
        await apiServiceSmart.updateSmart(context, modifySmart); 
      } else {
        if (kDebugMode) {
          print("Error: Faltan datos para la Edición.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: No se pudo actualizar la Manilla.\nDetalles: $e");
      }
    }
  }

  Future<void> asignSmart(BuildContext context, Smart asignSmart) async {
    try{
      if(asignSmart.idSmart != null && asignSmart.idUser != null){
        await apiServiceSmart.assignmentSmart(context, asignSmart);
        
      } else {
        if (kDebugMode) {
          print("Error: Faltan datos para la asignacion.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: No se pudo asignar la Manilla.\nDetalles: $e");
      }
    }
  }

  Future<void> removeSmart(BuildContext context, int? idSmart) async {
    try {
      if(idSmart != null && idSmart > 0){
        await apiServiceSmart.deleteSmart(context, idSmart);
      }
    } catch (e){
      if (kDebugMode){
        print("Error: No se pudo eliminar la Manilla.\n Detalles: $e");
      }
    }
  }

  int? updateSelectedNurseId(int id) {
    selectedNurseId = id;
    notifyListeners(); 
    return selectedNurseId;
  }
}
