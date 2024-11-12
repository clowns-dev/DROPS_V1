import 'package:flutter/foundation.dart';
import '../models/therapy.dart';
import '../services/api_service_therapy.dart';

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
        print('Error al obtener las terapias: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners(); 
    }
  }

  void filterTherapies(String query) {
    if (kDebugMode) {
      print('Filtrando terapias con consulta: $query');
    }
    if (query.isEmpty) {
      filteredTherapies = List.from(listTherapies); 
    } else {
      filteredTherapies = listTherapies.where((therapy) {
        return therapy.idTherapy.toString().contains(query) || 
               therapy.stretcherNumber.toString().contains(query) || 
               therapy.startDate.toString().contains(query) || 
               therapy.idPatient.toString().contains(query); 
      }).toList();
    }
    notifyListeners(); 
  }

  void deleteTherapy(int therapyId) {
    listTherapies.removeWhere((therapy) => therapy.idTherapy == therapyId);
    filterTherapies(''); 
    notifyListeners();
  }
}
