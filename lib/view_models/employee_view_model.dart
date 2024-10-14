import 'package:flutter/foundation.dart';
import 'package:ps3_drops_v1/models/employee.dart';
import 'package:ps3_drops_v1/services/api_service_employee.dart';

class EmployeeViewModel extends ChangeNotifier {
  ApiServiceEmployee apiServiceEmployee = ApiServiceEmployee();
  List<Employee> listEmployees = [];
  List<Employee> filteredEmployees = [];
  bool isLoading = false;
  bool hasMatches = true;


  EmployeeViewModel() {
    fetchEmployees();
    
  }


  Future<void> fetchEmployees() async {
    isLoading = true;
    notifyListeners();
    try {
      listEmployees = await apiServiceEmployee.fetchEmployees();
      filteredEmployees = List.from(listEmployees); 
      if (kDebugMode) {
        print('Usuarios cargados: ${listEmployees.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener los registros de Usuarios: $e');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
