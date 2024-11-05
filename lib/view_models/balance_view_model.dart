import 'package:flutter/foundation.dart';
import 'package:ps3_drops_v1/models/balance.dart';
import 'package:ps3_drops_v1/services/api_service_balance.dart';

class BalanceViewModel extends ChangeNotifier {
  ApiServiceBalance apiServiceBalance = ApiServiceBalance();
  List<Balance> listBalances = [];
  Balance? balance;
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

  Future<Balance?> fetchBalanceById(int id) async {
    isLoading = true;
    
    Balance? balance;
    try {
      balance = await apiServiceBalance.fetchBalanceById(id); 
      if (kDebugMode) {
        print('Balanza cargada: ${balance.balanceCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener el registro de Balanza: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return balance; // Retorna el objeto Balance recuperado
  }

  Future<void> createNewBalance(String? balanceCode, int? userId) async {
    try {
      if(balanceCode != null && userId != null){
        await apiServiceBalance.createBalance(balanceCode, userId);

        if(kDebugMode){
          print("Balanza creada Exitosamente!");
        } else {
          if(kDebugMode){
            print("Error: Faltan datos para la creacion.");
          }
        }
      }
    } catch (e){
      if (kDebugMode){
        print("Error: No se pudo crear la Balanza.\n Detalles: $e");
      }
    }
  }

  Future<void> editBalance(int? idBalance, String? balanceCode, int? userId) async {
    try {
      if(idBalance != null && balanceCode != null && userId != null){
        await apiServiceBalance.updateBalance(idBalance, balanceCode, userId);

        if(kDebugMode){
          print("Balanza Editada Exitosamente!");
        } else {
          if(kDebugMode){
            print("Error: Faltan datos para la Edicion.");
          }
        }
      }
    } catch (e){
      if (kDebugMode){
        print("Error: No se pudo actualizar la Balanza.\n Detalles: $e");
      }
    }
  }

  Future<void> removeBalance(int? idBalance, int? userId) async {
    try {
      if(idBalance != null && userId != null){
        await apiServiceBalance.deleteBalance(idBalance, userId);

        if(kDebugMode){
          print("Balanza Eliminada Exitosamente!");
        } else {
          if(kDebugMode){
            print("Error: Faltan datos para la eliminacion.");
          }
        }
      }
    } catch (e){
      if (kDebugMode){
        print("Error: No se pudo eliminar la Balanza.\n Detalles: $e");
      }
    }
  }
}