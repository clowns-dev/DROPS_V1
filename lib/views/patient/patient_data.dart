import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ps3_drops_v1/models/patient.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ps3_drops_v1/widgets/edit_button.dart';
import 'package:ps3_drops_v1/widgets/delete_button.dart';
import 'package:ps3_drops_v1/widgets/grid_column_builder.dart';

class PatientDataTable extends StatefulWidget {
  final List<Patient> patients;
  final void Function(int id) onEdit;
  final void Function(int id) onDelete;

  const PatientDataTable({
    required this.patients,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  State<PatientDataTable> createState() => _PatientDataTableState();
}

class _PatientDataTableState extends State<PatientDataTable> {
  late PatientDataSource _patientDataSource;
  int rowsPerPage = 5;
  @override
  void initState() {
    super.initState();
    _patientDataSource = PatientDataSource(
      patients: widget.patients,
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
            source: _patientDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            gridLinesVisibility: GridLinesVisibility.none,
            headerGridLinesVisibility: GridLinesVisibility.none,
            rowsPerPage: _patientDataSource.rowsPerPage,
            rowHeight: 50,
            columns: <GridColumn>[
              buildGridColumn('CI', 'CI'),
              buildGridColumn('Nombre', 'Nombre'),
              buildGridColumn('Apellido Paterno', 'Apellido Paterno'),
              buildGridColumn('Apellido Materno', 'Apellido Materno'),
              buildGridColumn('Fecha de Nacimiento', 'Fecha de Nacimiento'),
              buildGridColumn('Fecha de\nRegistro', 'Fecha de\nRegistro'),
              buildGridColumn('Fecha de\nActualizacion', 'Fecha de\nActualizacion'),
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
          delegate: _patientDataSource,
          availableRowsPerPage: const <int>[5, 10],
          pageCount: (widget.patients.length / _patientDataSource.rowsPerPage).ceil().toDouble(),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _patientDataSource.updateRowsPerPage(rowsPerPage!);
            });
          },
          onPageNavigationEnd: (int pageIndex) {
            setState(() {
              _patientDataSource.updatePage(pageIndex, _patientDataSource.rowsPerPage);
            });
          },
        ),
      ],
    );
  }
}

class PatientDataSource extends DataGridSource {
  int rowsPerPage = 5;
  int currentPageIndex = 0;

  PatientDataSource({
    required List<Patient> patients,
    required this.onEdit,
    required this.onDelete,
  }) {
    _patients = patients.map<DataGridRow>((patient) {
      final formattedRegisterDate = patient.registerDate != null
          ? DateFormat('yyyy-MM-dd').format(patient.registerDate!)
          : 'Sin Registro';
      final formattedLastUpdate = patient.lastUpdate != null
          ? DateFormat('yyyy-MM-dd').format(patient.lastUpdate!)
          : 'Sin Cambios';
      final formattedBirthDate = patient.birthDate != null
          ? DateFormat('yyyy-MM-dd').format(patient.birthDate!)
          : 'Sin Cambios';
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: patient.idPatient),
        DataGridCell<String>(columnName: 'CI', value: patient.ci),
        DataGridCell<String>(columnName: 'Nombre', value: patient.name),
        DataGridCell<String>(columnName: 'Apellido Paterno', value: patient.lastName),
        DataGridCell<String>(columnName: 'Apellido Materno', value: patient.secondLastName ?? 'No tiene'),
        DataGridCell<String>(columnName: 'Fecha de Nacimiento', value: formattedBirthDate),
        DataGridCell<String>(columnName: 'Fecha de\nRegistro', value: formattedRegisterDate),
        DataGridCell<String>(columnName: 'Fecha de\nActualizacion', value: formattedLastUpdate),
        DataGridCell<Widget>(
          columnName: 'Acciones',
          value: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EditButton(onPressed: () => onEdit(patient.idPatient!)),
              const SizedBox(width: 8),
              DeleteButton(onPressed: () => onDelete(patient.idPatient!)),
            ],
          ),
        ),
      ]);
    }).toList();
  }

  List<DataGridRow> _patients = [];
  final void Function(int id) onEdit;
  final void Function(int id) onDelete;

  void updatePage(int pageIndex, int rowsPerPage) {
    currentPageIndex = pageIndex;
    this.rowsPerPage = rowsPerPage;  
    notifyListeners();  
  }


  void updateRowsPerPage(int rowsPerPage) {
    this.rowsPerPage = rowsPerPage;
    currentPageIndex = 0; 
    notifyListeners(); 
  }

  @override
  List<DataGridRow> get rows {
    int startIndex = currentPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    endIndex = endIndex > _patients.length ? _patients.length : endIndex;
    return _patients.sublist(startIndex, endIndex);
  }

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
                    maxLines: 1,  
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
        );
      }).toList(),
    );
  }
}
