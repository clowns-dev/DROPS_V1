import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/employee.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ps3_drops_v1/widgets/edit_button.dart';
import 'package:ps3_drops_v1/widgets/delete_button.dart';
import 'package:ps3_drops_v1/widgets/grid_column_builder.dart';
import 'package:intl/intl.dart';

class EmployeeDataTable extends StatefulWidget {
  final List<Employee> employees;
  final void Function(int id) onEdit;
  final void Function(int id) onDelete;

  const EmployeeDataTable({
    required this.employees,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  State<EmployeeDataTable> createState() => _EmployeeDataTableState();
}

class _EmployeeDataTableState extends State<EmployeeDataTable> {
  late EmployeeDataSource _employeeDataSource;

  @override
  void initState() {
    super.initState();
    _employeeDataSource = EmployeeDataSource(
      employees: widget.employees,
      onEdit: widget.onEdit,
      onDelete: widget.onDelete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SfDataGrid(
            source: _employeeDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            gridLinesVisibility: GridLinesVisibility.none,
            headerGridLinesVisibility: GridLinesVisibility.none,
            columns: <GridColumn>[
              buildGridColumn('CI', 'CI'),
              buildGridColumn('Nombre', 'Nombre'),
              buildGridColumn('Apellido Paterno', 'Apellido Paterno'),
              buildGridColumn('Apellido Materno', 'Apellido Materno'),
              buildGridColumn('Fecha de Registro', 'Fecha de Registro'),
              buildGridColumn('Rol Usuario', 'Rol Usuario'),
              GridColumn(
                columnName: 'Acciones',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Acciones',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        SfDataPager(
          delegate: _employeeDataSource,
          availableRowsPerPage: const <int>[5, 10, 15],
          pageCount: (widget.employees.length / 10),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _employeeDataSource.updateRowsPerPage(rowsPerPage!);
            });
          },
        ),
      ],
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({
    required List<Employee> employees,
    required this.onEdit,
    required this.onDelete,
  }) {
    
    _employees = employees.map<DataGridRow>((employee) {
      final formattedDate = employee.registerDate != null
          ? DateFormat('yyyy-MM-dd').format(employee.registerDate!)
          : 'No registrado';

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: employee.idEmployee),
        DataGridCell<String>(columnName: 'CI', value: employee.ci),
        DataGridCell<String>(columnName: 'Nombre', value: employee.name),
        DataGridCell<String>(columnName: 'Apellido Paterno', value: employee.lastName),
        DataGridCell<String>(columnName: 'Apellido Materno', value: employee.secondLastName),
        DataGridCell<String>(columnName: 'Fecha de Registro', value: formattedDate),
        DataGridCell<String>(columnName: 'Rol Usuario', value: employee.rolName ?? 'No asignado'),
        DataGridCell<Widget>(
          columnName: 'Acciones',
          value: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EditButton(onPressed: () => onEdit(employee.idEmployee!)),
              const SizedBox(width: 8),
              DeleteButton(onPressed: () => onDelete(employee.idEmployee!)),
            ],
          ),
        ),
      ]);
    }).toList();
  }

  List<DataGridRow> _employees = [];
  final void Function(int id) onEdit;
  final void Function(int id) onDelete;

  @override
  List<DataGridRow> get rows => _employees;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().where((dataGridCell) {
        return dataGridCell.columnName != 'ID';
      }).map<Widget>((dataGridCell) {
        bool isActionColumn = dataGridCell.columnName == 'Acciones';
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: isActionColumn
              ? dataGridCell.value
              : Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE4E1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                  child: Text(
                    dataGridCell.value.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
        );
      }).toList(),
    );
  }

  void updateRowsPerPage(int rowsPerPage) {
    notifyListeners();
  }
}
