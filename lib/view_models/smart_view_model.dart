import 'package:flutter/foundation.dart';
import 'package:ps3_drops_v1/models/smart.dart';
import 'package:ps3_drops_v1/services/api_service_smart.dart';

class SmartViewModel extends ChangeNotifier {
  ApiServiceSmart apiServiceSmart = ApiServiceSmart();
  List<Therapy> listSmarts = [];
  List<Therapy> filteredSmarts = [];
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
      if (kDebugMode) {
        print('Balanzas cargadas: ${listSmarts.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener los registros de Balanzas: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterBalances(String query) {
    if (kDebugMode) {
      print('Filtrando balanzas con consulta: $query');
    } 
    if (query.isEmpty) {
      filteredSmarts = List.from(listSmarts);
    } else {
      filteredSmarts = listSmarts.where((smart) {
        return smart.codeRFID!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void deleteSmart(int smartId) {
    listSmarts.removeWhere((smart) => smart.idSmart == smartId);
    filterBalances(''); 
    notifyListeners();
  }
}