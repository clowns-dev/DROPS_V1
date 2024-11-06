import 'package:flutter/foundation.dart';
import 'package:ps3_drops_v1/models/smart.dart';
import 'package:ps3_drops_v1/services/api_service_smart.dart';

class SmartViewModel extends ChangeNotifier {
  ApiServiceSmart apiServiceSmart = ApiServiceSmart();
  Smart? smart;
  List<Smart> listSmarts = [];  
  List<Smart> filteredSmarts = []; 
  bool isLoading = false;
  bool hasMatches = true;

  SmartViewModel() {
    fetchSmarts();
  }

  Future<void> fetchSmarts() async {
    isLoading = true;
    notifyListeners();
    
    try {
      listSmarts = await apiServiceSmart.fetchSmarts();
      filteredSmarts = List.from(listSmarts); 
      hasMatches = filteredSmarts.isNotEmpty;
      if (kDebugMode) {
        print('Manillas cargadas: ${listSmarts.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener los registros de Manillas: $e');
      }
    } finally {
      isLoading = false;  // Asegúrate de que esto esté aquí
      notifyListeners();
    }
  }


  void filterSmarts(String query, String field) {
    if (query.isEmpty || field == 'Buscar por:') {
      // Si el campo de búsqueda está vacío o se selecciona la opción por defecto, mostrar todos los registros
      filteredSmarts = List.from(listSmarts);
    } else {
      // Filtra la lista según el campo seleccionado
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



  Future<Smart?> fetchBalanceById(int id) async {
    isLoading = true;
    Smart? smart;
    try {
      smart = await apiServiceSmart.fetchSmartById(id); 
      if (kDebugMode) {
        print('Balanza cargada: ${smart.codeRFID}');
      }
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

  Future<void> createNewSmart(Smart newSmart) async {
    try {
      if(newSmart.codeRFID != null){
        await apiServiceSmart.createSmart(newSmart);
        await fetchSmarts(); // Actualiza la lista después de crear
        if(kDebugMode){
          print("Manilla creada Exitosamente!");
        } else {
          if(kDebugMode){
            print("Error: Faltan datos para la creacion.");
          }
        }
      }
    } catch (e){
      if (kDebugMode){
        print("Error: No se pudo crear la Manilla.\n Detalles: $e");
      }
    }
  }

  Future<void> editSmart(Smart modifySmart) async {
    try {
      if (modifySmart.idSmart != null &&
          modifySmart.codeRFID != null &&
          modifySmart.available != null &&
          modifySmart.idUser != null) {
          
        await apiServiceSmart.updateSmart(modifySmart); 
        if (kDebugMode) {
          print("Manilla Editada Exitosamente!");
        }
        
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

  Future<void> removeSmart(int? idSmart) async {
    try {
      if(idSmart != null && idSmart > 0){
        await apiServiceSmart.deleteSmart(idSmart);
        await fetchSmarts();
        if(kDebugMode){
          print("Manilla Eliminada Exitosamente!");
        } else {
          if(kDebugMode){
            print("Error: Faltan datos para la eliminacion.");
          }
        }
      }
    } catch (e){
      if (kDebugMode){
        print("Error: No se pudo eliminar la Manilla.\n Detalles: $e");
      }
    }
  }
}
