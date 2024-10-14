import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/widgets/grid_column_builder.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ps3_drops_v1/widgets/checkbox_to_table.dart';

class TherapyPatientsDataTable extends StatefulWidget {
  final List<Patient> therapyPatients;
  final int? selectedId;
  final void Function(int id) onAssign;

  const TherapyPatientsDataTable({
    required this.therapyPatients,
    required this.selectedId,
    required this.onAssign,
    super.key,
  });

  @override
  State<TherapyPatientsDataTable> createState() => _TherapyPatientsDataTableState();
}

class _TherapyPatientsDataTableState extends State<TherapyPatientsDataTable> {
  int? selectedId;
  late TherapyPatientsDataSource _therapyPatientsDataSource;
  int rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    selectedId = widget.selectedId;
    _therapyPatientsDataSource = TherapyPatientsDataSource(
      therapyPatients: widget.therapyPatients,
      onSelect: _handleCheckboxChanged,
      selectedId: selectedId,
    );
  }

  void _handleCheckboxChanged(int id) {
    setState(() {
      selectedId = id;
      _therapyPatientsDataSource.updateSelectedId(id); 
    });
    widget.onAssign(id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Pacientes',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: SfDataGrid(
            source: _therapyPatientsDataSource,
            columnWidthMode: ColumnWidthMode.auto,
            gridLinesVisibility: GridLinesVisibility.none,
            headerGridLinesVisibility: GridLinesVisibility.none,
            rowsPerPage: _therapyPatientsDataSource.rowsPerPage,
            rowHeight: 50,
            columns: <GridColumn>[
              buildGridColumn('Paciente', 'Paciente'),
              buildGridColumn('CI', 'CI'),
              GridColumn(
                columnName: 'Asignar',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Asignar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        SfDataPager(
          delegate: _therapyPatientsDataSource,
          availableRowsPerPage: const <int>[5, 10],
          pageCount: (widget.therapyPatients.length / _therapyPatientsDataSource.rowsPerPage).ceil().toDouble(),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _therapyPatientsDataSource.updateRowsPerPage(rowsPerPage!);
            });
          },
          onPageNavigationEnd: (int pageIndex) {  
            setState(() {
              _therapyPatientsDataSource.updatePage(pageIndex, rowsPerPage);  
            });
          },
        ),
      ],
    );
  }
}

class TherapyPatientsDataSource extends DataGridSource {
  TherapyPatientsDataSource({
    required List<Patient> therapyPatients,
    required this.onSelect,
    this.selectedId,
  }) {
    _patients = therapyPatients.map<DataGridRow>((patient) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: patient.idPerson),
        DataGridCell<String>(columnName: 'Paciente', value: patient.patient),
        DataGridCell<String>(columnName: 'CI', value: patient.ci),
        DataGridCell<Widget>(
          columnName: 'Asignar',
          value: CheckboxToTable(
            isChecked: patient.idPerson == selectedId,
            onChanged: () {
              onSelect(patient.idPerson!);
            },
          ),
        ),
      ]);
    }).toList();
  }

  List<DataGridRow> _patients = [];
  final void Function(int id) onSelect;
  int? selectedId;
  int rowsPerPage = 5;
  int currentPageIndex = 0;

  void updateSelectedId(int selectedId) {
    this.selectedId = selectedId;
    _patients = _patients.map<DataGridRow>((row) {
      final balanceId = row.getCells().firstWhere((cell) => cell.columnName == 'ID').value;
      
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: balanceId),
        DataGridCell<String>(columnName: 'Paciente', value: row.getCells().firstWhere((cell) => cell.columnName == 'Paciente').value),
        DataGridCell<String>(columnName: 'CI', value: row.getCells().firstWhere((cell) => cell.columnName == 'CI').value),
        DataGridCell<Widget>(
          columnName: 'Asignar',
          value: CheckboxToTable(
            isChecked: balanceId == selectedId,
            onChanged: () {
              onSelect(balanceId);
            },
          ),
        ),
      ]);
    }).toList();
    notifyListeners();
  }


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
        bool isActionColumn = dataGridCell.columnName == 'Asignar';

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
}