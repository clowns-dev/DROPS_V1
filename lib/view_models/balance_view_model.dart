import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/balance.dart';
import 'package:ps3_drops_v1/services/api_middleware.dart';
import 'package:ps3_drops_v1/services/api_service_balance.dart';

class BalanceViewModel extends ChangeNotifier {
  final ApiMiddleware _apiMiddleware = ApiMiddleware();
  late final ApiServiceBalance apiServiceBalance = ApiServiceBalance(_apiMiddleware);
  List<Balance> listBalances = [];
  Balance? balance;
  List<Balance> filteredBalances = [];
  bool isLoading = false;
  bool hasMatches = true;


  BalanceViewModel();


  Future<void> fetchBalances(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      listBalances = await apiServiceBalance.fetchBalances(context);
      filteredBalances = List.from(listBalances); 
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener los registros de Balanzas: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Balance?> fetchBalanceById(BuildContext context, int id) async {
    isLoading = true;
    
    Balance? balance;
    try {
      balance = await apiServiceBalance.fetchBalanceById(context, id); 
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener el registro de Balanza: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return balance; 
  }

  Future<bool> isCodeRegistered(BuildContext context, String code) async {
    try {
      return await apiServiceBalance.verifyExistBalance(context, code);
    } catch (e) {
      if (kDebugMode) {
        print('Error al verificar si la balanza está registrada: $e');
      }
      return false;
    }
  }

  void filterBalances(String query, String field) {
    if (query.isEmpty || field == 'Buscar por:') {
      filteredBalances = List.from(listBalances);
    } else {
      switch (field) {
        case 'Codigo':
          filteredBalances = listBalances
              .where((balance) => balance.balanceCode?.toLowerCase().contains(query.toLowerCase()) ?? false)
              .toList();
          break;
        default:
          filteredBalances = List.from(listBalances);
      }
    }

    hasMatches = filteredBalances.isNotEmpty;
    notifyListeners();
  }

  Future<void> createNewBalance(BuildContext context, Balance newBalance) async {
    try {
      if(newBalance.balanceCode != null && newBalance.userID != null){
        await apiServiceBalance.createBalance(context, newBalance);
      }
    } catch (e){
      if (kDebugMode){
        print("Error: No se pudo crear la Balanza.\n Detalles: $e");
      }
    }
  }

  Future<void> editBalance(BuildContext context, Balance updateBalance) async {
    try {
      if(updateBalance.idBalance != null && updateBalance.balanceCode != null && updateBalance.userID != null){
        await apiServiceBalance.updateBalance(context, updateBalance);
      }
    } catch (e){
      if (kDebugMode){
        print("Error: No se pudo actualizar la Balanza.\n Detalles: $e");
      }
    }
  }

  Future<void> removeBalance(BuildContext context, int? idBalance, int? userId) async {
    try {
      if(idBalance != null && userId != null){
        await apiServiceBalance.deleteBalance(context, idBalance, userId);
      }
    } catch (e){
      if (kDebugMode){
        print("Error: No se pudo eliminar la Balanza.\n Detalles: $e");
      }
    }
  }
}