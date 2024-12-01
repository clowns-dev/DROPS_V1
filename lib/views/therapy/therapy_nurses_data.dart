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

  void _handleCheckboxChanged(int id) {
    setState(() {
      selectedId = id;
      _therapyNursesDataSource.updateSelectedId(id); 
    });
    widget.onAssign(id);
  }

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

  @override
  void didUpdateWidget(covariant TherapyNursesDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.therapyNurses != widget.therapyNurses) {
      _therapyNursesDataSource.updateDataSource(widget.therapyNurses);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SfDataGrid(
            source: _therapyNursesDataSource, 
            columnWidthMode: ColumnWidthMode.fill,
            gridLinesVisibility: GridLinesVisibility.none,
            headerGridLinesVisibility: GridLinesVisibility.none,
            rowsPerPage: _therapyNursesDataSource.rowsPerPage,
            rowHeight: 50,
            columns: <GridColumn>[
              GridColumn(
                columnName: 'Enfermero', 
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Enfermero',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                width: 250
              ),
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
          delegate: _therapyNursesDataSource,  // Usa la instancia existente
          availableRowsPerPage: const <int>[5, 10],
          pageCount: (widget.therapyNurses.length / _therapyNursesDataSource.rowsPerPage).ceil().toDouble(),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _therapyNursesDataSource.updateRowsPerPage(rowsPerPage!);  
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
  List<DataGridRow> _nurses = [];
  final void Function(int id) onSelect;
  int? selectedId;
  int rowsPerPage = 5;
  int currentPageIndex = 0;


  TherapyNursesDataSource({
    required List<Nurse> therapyNurses,
    required this.onSelect,
    this.selectedId,
  }) {
    _buildDataGridRows(therapyNurses);
  }

  void _buildDataGridRows(List<Nurse> therapyNurses){
    _nurses = therapyNurses.map<DataGridRow>((nurse) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: nurse.idNurse ?? -1),
        DataGridCell<String>(columnName: 'Enfermero', value: nurse.fullName ?? 'Desconocido'),
        DataGridCell<String>(columnName: 'CI', value: nurse.ci ?? 'N/A'),
        DataGridCell<Widget>(
          columnName: 'Asignar',
          value: CheckboxToTable(
            isChecked: nurse.idNurse == selectedId,
            onChanged: () {
              if (nurse.idNurse != null) {
                onSelect(nurse.idNurse!);
              }
            },
          ),
        ),
      ]);
    }).toList();
  } 

  void updateDataSource(List<Nurse> nurses) {
    _buildDataGridRows(nurses);  
    notifyListeners();        
  }

  void updateSelectedId(int selectedId) {
    this.selectedId = selectedId;
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
    final nurseId = row.getCells().firstWhere((cell) => cell.columnName == 'ID').value as int? ?? -1;

    return DataGridRowAdapter(
      cells: row.getCells().where((dataGridCell) {
        return dataGridCell.columnName != 'ID';
      }).map<Widget>((dataGridCell) {
        bool isActionColumn = dataGridCell.columnName == 'Asignar';

        return GestureDetector(
          onTap: () {
            onSelect(nurseId);
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: isActionColumn
                ? CheckboxToTable(
                    isChecked: nurseId == selectedId,
                    onChanged: () {
                      if (nurseId != -1) onSelect(nurseId);
                    },
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4E1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                    child: Text(
                      dataGridCell.value?.toString() ?? 'N/A',
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