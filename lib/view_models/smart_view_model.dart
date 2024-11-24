import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/smart.dart';
import 'package:ps3_drops_v1/services/api_middleware.dart';
import 'package:ps3_drops_v1/services/api_service_smart.dart';

class SmartViewModel extends ChangeNotifier {
  final ApiMiddleware _apiMiddleware = ApiMiddleware();
  late final ApiServiceSmart apiServiceSmart = ApiServiceSmart(_apiMiddleware);
  Smart? smart;
  List<Smart> listSmarts = [];  
  List<Smart> filteredSmarts = []; 
  bool isLoading = false;
  bool hasMatches = true;

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
}
