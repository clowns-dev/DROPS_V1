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

  void filterEmployees(String query) {
    if (kDebugMode) {
      print('Filtrando empleados con consulta: $query');
    } 
    if (query.isEmpty) {
      filteredEmployees = List.from(listEmployees);
    } else {
      filteredEmployees = listEmployees.where((employee) {
        return employee.ci.toLowerCase().contains(query.toLowerCase()) ||
              employee.name.toLowerCase().contains(query.toLowerCase()) ||
              employee.lastName.toLowerCase().contains(query.toLowerCase()) ||
              employee.secondLastName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void deleteEmployee(int? employeeId) {
    listEmployees.removeWhere((employee) => employee.idEmployee == employeeId);
    filterEmployees(''); 
    notifyListeners();
  }
}
