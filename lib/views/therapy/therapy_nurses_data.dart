import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/widgets/grid_column_builder.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ps3_drops_v1/widgets/checkbox_to_table.dart';

class TherapyNursesDataTable extends StatefulWidget {
  final List<Nurse> therapyNurses;
  final int? selectedId;
  final void Function(int id) onAssign;

  const TherapyNursesDataTable({
    required this.therapyNurses,
    required this.selectedId,
    required this.onAssign,
    super.key,
  });

  @override
  State<TherapyNursesDataTable> createState() => _TherapyNursesDataTableState();
}

class _TherapyNursesDataTableState extends State<TherapyNursesDataTable> {
  int? selectedId;
  late TherapyNursesDataSource _therapyNursesDataSource;
  int rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    selectedId = widget.selectedId;
    _therapyNursesDataSource = TherapyNursesDataSource(
      therapyNurses: widget.therapyNurses,
      onSelect: _handleCheckboxChanged,
      selectedId: selectedId,
    );
  }

  void _handleCheckboxChanged(int id) {
    setState(() {
      selectedId = id;
      _therapyNursesDataSource.updateSelectedId(id); 
    });
    widget.onAssign(id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Enfermeros',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: SfDataGrid(
            source: _therapyNursesDataSource, 
            columnWidthMode: ColumnWidthMode.auto,
            gridLinesVisibility: GridLinesVisibility.none,
            headerGridLinesVisibility: GridLinesVisibility.none,
            rowsPerPage: _therapyNursesDataSource.rowsPerPage,
            rowHeight: 50,
            columns: <GridColumn>[
              buildGridColumn('Enfermero', 'Enfermero'),
              buildGridColumn('Cargo', 'Cargo'),
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
          delegate: _therapyNursesDataSource,  // Usa la instancia existente
          availableRowsPerPage: const <int>[5, 10],
          pageCount: (widget.therapyNurses.length / _therapyNursesDataSource.rowsPerPage).ceil().toDouble(),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _therapyNursesDataSource.updateRowsPerPage(rowsPerPage!);  // Actualiza la cantidad de filas por página
            });
          },
          onPageNavigationEnd: (int pageIndex) {
            setState(() {
              _therapyNursesDataSource.updatePage(pageIndex, rowsPerPage);  // Cambia la página actual
            });
          },
        ),
      ],
    );
  }
}

class TherapyNursesDataSource extends DataGridSource {
  TherapyNursesDataSource({
    required List<Nurse> therapyNurses,
    required this.onSelect,
    this.selectedId,
  }) {
    _nurses = therapyNurses.map<DataGridRow>((nurse) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: nurse.idNurse),
        DataGridCell<String>(columnName: 'Enfermero', value: nurse.fullName),
        DataGridCell<String>(columnName: 'Cargo', value: nurse.role),
        DataGridCell<Widget>(
          columnName: 'Asignar',
          value: CheckboxToTable(
            isChecked: nurse.idNurse == selectedId,
            onChanged: () {
              onSelect(nurse.idNurse!);
            },
          ),
        ),
      ]);
    }).toList();
  }

  List<DataGridRow> _nurses = [];
  final void Function(int id) onSelect;
  int? selectedId;
  int rowsPerPage = 5;
  int currentPageIndex = 0;

  void updateSelectedId(int selectedId) {
    this.selectedId = selectedId;
    _nurses = _nurses.map<DataGridRow>((row) {
      final nurseId = row.getCells().firstWhere((cell) => cell.columnName == 'ID').value;
      
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: nurseId),
        DataGridCell<String>(columnName: 'Enfermero', value: row.getCells().firstWhere((cell) => cell.columnName == 'Enfermero').value),
        DataGridCell<String>(columnName: 'Cargo', value: row.getCells().firstWhere((cell) => cell.columnName == 'Cargo').value),
        DataGridCell<Widget>(
          columnName: 'Asignar',
          value: CheckboxToTable(
            isChecked: nurseId == selectedId,
            onChanged: () {
              onSelect(nurseId);
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
    endIndex = endIndex > _nurses.length ? _nurses.length : endIndex;
    return _nurses.sublist(startIndex, endIndex);  
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
                    maxLines: 1,  
                    overflow: TextOverflow.ellipsis,  
                  ),
                ),
        );
      }).toList(),
    );
  }
}
