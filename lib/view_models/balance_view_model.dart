import 'package:flutter/foundation.dart';
import 'package:ps3_drops_v1/models/balance.dart';
import 'package:ps3_drops_v1/services/api_service_balance.dart';

class BalanceViewModel extends ChangeNotifier {
  ApiServiceBalance apiServiceBalance = ApiServiceBalance();
  List<Balance> listBalances = [];
  List<Balance> filteredBalances = [];
  bool isLoading = false;
  bool hasMatches = true;


  BalanceViewModel() {
    fetchBalances();
    
  }


  Future<void> fetchBalances() async {
    isLoading = true;
    notifyListeners();
    try {
      listBalances = await apiServiceBalance.fetchBalances();
      filteredBalances = List.from(listBalances); 
      if (kDebugMode) {
        print('Balanzas cargadas: ${listBalances.length}');
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
      filteredBalances = List.from(listBalances);
    } else {
      filteredBalances = listBalances.where((balance) {
        return balance.balanceCode!.toLowerCase().contains(query.toLowerCase()) ||
              balance.actuallyFactor?.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void deleteBalance(int balanceId) {
    listBalances.removeWhere((balance) => balance.idBalance == balanceId);
    filterBalances(''); 
    notifyListeners();
  }
}

extension on double? {
  toLowerCase() {}
}
