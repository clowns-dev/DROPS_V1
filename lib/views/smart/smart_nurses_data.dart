import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/widgets/grid_column_builder.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ps3_drops_v1/widgets/checkbox_to_table.dart';

class SmartNursesDataTable extends StatefulWidget {
  final List<Nurse> smartNurses;
  final int? selectedId;
  final void Function(int id) onAssign;

  const SmartNursesDataTable({
    required this.smartNurses,
    required this.selectedId,
    required this.onAssign,
    super.key,
  });

  @override
  State<SmartNursesDataTable> createState() => _SmartNursesDataTableState();
}

class _SmartNursesDataTableState extends State<SmartNursesDataTable> {
  int? selectedId;
  late SmartNursesDataSource _smartNursesDataSource;
  int rowsPerPage = 5;

  void _handleCheckboxChanged(int id) {
    setState(() {
      selectedId = id;
      _smartNursesDataSource.updateSelectedId(id); 
    });
    widget.onAssign(id);
  }

  @override
  void initState() {
    super.initState();
    selectedId = widget.selectedId;
    _smartNursesDataSource = SmartNursesDataSource(
      smartNurses: widget.smartNurses,
      onSelect: _handleCheckboxChanged,
      selectedId: selectedId,
    );
  }

  @override
  void didUpdateWidget(covariant SmartNursesDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.smartNurses != widget.smartNurses) {
      _smartNursesDataSource.updateDataSource(widget.smartNurses);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SfDataGrid(
            source: _smartNursesDataSource, 
            columnWidthMode: ColumnWidthMode.fill,
            gridLinesVisibility: GridLinesVisibility.none,
            headerGridLinesVisibility: GridLinesVisibility.none,
            rowsPerPage: _smartNursesDataSource.rowsPerPage,
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
          delegate: _smartNursesDataSource,  
          availableRowsPerPage: const <int>[5, 10],
          pageCount: (widget.smartNurses.length / _smartNursesDataSource.rowsPerPage).ceil().toDouble(),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _smartNursesDataSource.updateRowsPerPage(rowsPerPage!);  
            });
          },
          onPageNavigationEnd: (int pageIndex) {
            setState(() {
              _smartNursesDataSource.updatePage(pageIndex, rowsPerPage); 
            });
          },
        ),
      ],
    );
  }
}

class SmartNursesDataSource extends DataGridSource {
  List<DataGridRow> _nurses = [];
  final void Function(int id) onSelect;
  int? selectedId;
  int rowsPerPage = 5;
  int currentPageIndex = 0;


  SmartNursesDataSource({
    required List<Nurse> smartNurses,
    required this.onSelect,
    this.selectedId,
  }) {
    _buildDataGridRows(smartNurses);
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