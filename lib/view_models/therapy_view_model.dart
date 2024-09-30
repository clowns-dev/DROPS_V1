import 'package:flutter/foundation.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/services/api_service_therapy.dart';

class TherapyViewModel extends ChangeNotifier {
  ApiServiceTherapy apiServiceTherapy = ApiServiceTherapy();
  List<Therapy> listTherapies = [];
  List<Therapy> filteredTherapies = [];
  bool isLoading = false;
  bool hasMatches = true;


  TherapyViewModel() {
    fetchTherapies();
  }


  Future<void> fetchTherapies() async {
    isLoading = true;
    notifyListeners();
    try {
      listTherapies = await apiServiceTherapy.fetchTherapies();
      filteredTherapies = List.from(listTherapies); 
      if (kDebugMode) {
        print('Terapias cargadas: ${listTherapies.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener los registros de Terapias: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterBalances(String query) {
    if (kDebugMode) {
      print('Filtrando de Terapias con consulta: $query');
    } 
    if (query.isEmpty) {
      filteredTherapies = List.from(listTherapies);
    } else {
      filteredTherapies = listTherapies.where((therapy) {
        return therapy.stretcherNumber?.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void deletePatient(int therapyId) {
    listTherapies.removeWhere((therapy) => therapy.idTherapy == therapyId);
    filterBalances(''); 
    notifyListeners();
  }
}

extension on int? {
  toLowerCase() {}
}