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

  void _handleCheckboxChanged(int id) {
    setState(() {
      selectedId = id;
      _therapyPatientsDataSource.updateSelectedId(id); 
    });
    widget.onAssign(id);
  }


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

  @override
  void didUpdateWidget(covariant TherapyPatientsDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.therapyPatients != widget.therapyPatients) {
      _therapyPatientsDataSource.updateDataSource(widget.therapyPatients);
    }
  }
 

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
  List<DataGridRow> _patients = [];
  final void Function(int id) onSelect;
  int? selectedId;
  int rowsPerPage = 5;
  int currentPageIndex = 0;

  
  TherapyPatientsDataSource({
    required List<Patient> therapyPatients,
    required this.onSelect,
    this.selectedId,
  }) {
    _buildDataGridRows(therapyPatients);
  }

  void _buildDataGridRows(List<Patient> therapyPatients) {
    _patients = therapyPatients.map<DataGridRow>((patient) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: patient.idPerson),
        DataGridCell<String>(columnName: 'Paciente', value: patient.patient ?? 'Desconocido'),
        DataGridCell<String>(columnName: 'CI', value: patient.ci ?? 'N/A'),
        DataGridCell<Widget>(
          columnName: 'Asignar',
          value: CheckboxToTable(
            isChecked: patient.idPerson == selectedId,
            onChanged: () {
              if (patient.idPerson != null) {
                onSelect(patient.idPerson!);
              }
            },
          ),
        ),
      ]);
    }).toList();
  }

  void updateDataSource(List<Patient> patients) {
    _buildDataGridRows(patients);
    notifyListeners();
  }

  void updateSelectedId(int selectedId) {
    this.selectedId = selectedId;
    notifyListeners(); // Solo notifica el cambio sin recrear la lista
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
    final int patientId = row.getCells().firstWhere((cell) => cell.columnName == 'ID').value ?? -1;

    return DataGridRowAdapter(
      cells: row.getCells().where((dataGridCell) {
        return dataGridCell.columnName != 'ID';
      }).map<Widget>((dataGridCell) {
        bool isActionColumn = dataGridCell.columnName == 'Asignar';

        return GestureDetector(
          onTap: () {
            onSelect(patientId); // Marca al hacer clic en cualquier parte de la fila
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: isActionColumn
                ? CheckboxToTable(
                    isChecked: patientId == selectedId,
                    onChanged: () {
                      if (patientId != -1) onSelect(patientId); // Marca solo un checkbox
                    },
                  )
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
          ),
        );
      }).toList(),
    );
  }
}
