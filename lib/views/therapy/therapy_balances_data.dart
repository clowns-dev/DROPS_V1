import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/widgets/grid_column_builder.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ps3_drops_v1/widgets/checkbox_to_table.dart';

class TherapyBalancesDataTable extends StatefulWidget {
  final List<Balance> therapyBalances;
  final int? selectedId; 
  final void Function(int id) onAssign;

  const TherapyBalancesDataTable({
    required this.therapyBalances,
    required this.selectedId, 
    required this.onAssign, 
    super.key,
  });

  @override
  State<TherapyBalancesDataTable> createState() => _TherapyBalancesDataTableState();
}

class _TherapyBalancesDataTableState extends State<TherapyBalancesDataTable> {
  int? selectedId;
  late TherapyBalancesDataSource _therapyBalancesDataSource; 
  int rowsPerPage = 5; 

  @override
  void initState() {
    super.initState();
    selectedId = widget.selectedId;
    _therapyBalancesDataSource = TherapyBalancesDataSource(
      therapyBalances: widget.therapyBalances,
      onSelect: _handleCheckboxChanged,
      selectedId: selectedId,
    );
  }

  void _handleCheckboxChanged(int id) {
    setState(() {
      selectedId = id;
      _therapyBalancesDataSource.updateSelectedId(id); 
    });
    widget.onAssign(id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Balanzas',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: SfDataGrid(
            source: _therapyBalancesDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            gridLinesVisibility: GridLinesVisibility.none,
            headerGridLinesVisibility: GridLinesVisibility.none,
            rowsPerPage: _therapyBalancesDataSource.rowsPerPage,
            rowHeight: 50,
            columns: <GridColumn>[
              buildGridColumn('Balanza', 'Balanza'),
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
          delegate: _therapyBalancesDataSource,
          availableRowsPerPage: const <int>[5, 10],
          pageCount: (widget.therapyBalances.length / _therapyBalancesDataSource.rowsPerPage).ceil().toDouble(),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _therapyBalancesDataSource.updateRowsPerPage(rowsPerPage!);
            });
          },
          onPageNavigationEnd: (int pageIndex) {  
            setState(() {
              _therapyBalancesDataSource.updatePage(pageIndex, rowsPerPage);  
            });
          },
        ),
      ],
    );
  }
}

class TherapyBalancesDataSource extends DataGridSource {
  TherapyBalancesDataSource({
    required List<Balance> therapyBalances,
    required this.onSelect,
    this.selectedId,
  }) {
    _balances = therapyBalances.map<DataGridRow>((balance) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: balance.idBalance),
        DataGridCell<String>(columnName: 'Balanza', value: balance.code),
        DataGridCell<Widget>(
          columnName: 'Asignar',
          value: CheckboxToTable(
            isChecked: balance.idBalance == selectedId,
            onChanged: () {
              onSelect(balance.idBalance!);
            },
          ),
        ),
      ]);
    }).toList();
  }

  List<DataGridRow> _balances = [];
  final void Function(int id) onSelect;
  int? selectedId;
  int rowsPerPage = 5;
  int currentPageIndex = 0;

  void updateSelectedId(int selectedId) {
    this.selectedId = selectedId;
    _balances = _balances.map<DataGridRow>((row) {
      final balanceId = row.getCells().firstWhere((cell) => cell.columnName == 'ID').value;
      
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: balanceId),
        DataGridCell<String>(columnName: 'Balanza', value: row.getCells().firstWhere((cell) => cell.columnName == 'Balanza').value),
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
    endIndex = endIndex > _balances.length ? _balances.length : endIndex;
    return _balances.sublist(startIndex, endIndex);
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
