import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ps3_drops_v1/models/balance.dart';
import 'package:ps3_drops_v1/widgets/checkbox_to_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ps3_drops_v1/widgets/edit_button.dart';
import 'package:ps3_drops_v1/widgets/delete_button.dart';
import 'package:ps3_drops_v1/widgets/grid_column_builder.dart';

class BalanceDataTable extends StatefulWidget {
  final List<Balance> balances;
  final void Function(int id) onEdit;
  final void Function(int id) onDelete;

  const BalanceDataTable({
    required this.balances,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  State<BalanceDataTable> createState() => _BalanceDataTableState();
}

class _BalanceDataTableState extends State<BalanceDataTable> {
  late BalanceDataSource _balanceDataSource;
  int rowsPerPage = 5;
  @override
  void initState() {
    super.initState();
    _balanceDataSource = BalanceDataSource(
      balances: widget.balances,
      onEdit: widget.onEdit,
      onDelete: widget.onDelete,
    );
  }

  @override
  void didUpdateWidget(covariant BalanceDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.balances != widget.balances) {
      _balanceDataSource.updateDataSource(widget.balances);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SfDataGrid(
            source: _balanceDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            gridLinesVisibility: GridLinesVisibility.none,
            headerGridLinesVisibility: GridLinesVisibility.none,
            rowsPerPage: _balanceDataSource.rowsPerPage,
            rowHeight: 50,
            columns: <GridColumn>[
              buildGridColumn('Codigo', 'Codigo'),
              buildGridColumn('Factor de\nCalibracion', 'Factor de\nCalibracion'),
              buildGridColumn('Fecha de\nRegistro', 'Fecha de\nRegistro'),
              buildGridColumn('Fecha de\nActualizacion', 'Fecha de\nActualizacion'),
              buildGridColumn('Estado', 'Estado'),
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
          delegate: _balanceDataSource,
          availableRowsPerPage: const <int>[5, 10],
          pageCount: (widget.balances.length / _balanceDataSource.rowsPerPage).ceil().toDouble(),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _balanceDataSource.updateRowsPerPage(rowsPerPage!);
            });
          },
          onPageNavigationEnd: (int pageIndex) {
            setState(() {
              _balanceDataSource.updatePage(pageIndex, _balanceDataSource.rowsPerPage);
            });
          },
        ),
      ],
    );
  }
}

class BalanceDataSource extends DataGridSource {
  int rowsPerPage = 5;
  int currentPageIndex = 0;
  List<DataGridRow> _balances = [];

  final void Function(int id) onEdit;
  final void Function(int id) onDelete;

  BalanceDataSource({
    required List<Balance> balances,
    required this.onEdit,
    required this.onDelete,
  }) {
    _buildDataGridRows(balances);
  }

  void _buildDataGridRows(List<Balance> balances){
    _balances = balances.map<DataGridRow>((balance) {
      final formattedRegisterDate = balance.registerDate != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(balance.registerDate!)
          : 'Sin Registro';
      final formattedLastUpdate = balance.updateRegister != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(balance.updateRegister!)
          : 'Sin Cambios';

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: balance.idBalance),
        DataGridCell<String>(columnName: 'Codigo', value: balance.balanceCode),
        DataGridCell<String>(columnName: 'Factor de\nCalibracion', value: balance.factor.toString()),
        DataGridCell<String>(columnName: 'Fecha de\nRegistro', value: formattedRegisterDate),
        DataGridCell<String>(columnName: 'Fecha de\nActualizacion', value: formattedLastUpdate),
        DataGridCell<bool>(columnName: 'Estado', value: balance.available == 1),
        DataGridCell<Widget>(
          columnName: 'Acciones',
          value: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EditButton(onPressed: () => onEdit(balance.idBalance!)),
              const SizedBox(width: 8),
              DeleteButton(onPressed: () => onDelete(balance.idBalance!)),
            ],
          ),
        ),
      ]);
    }).toList();
  }

  void updateDataSource(List<Balance> balances) {
    _buildDataGridRows(balances);  
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
        bool isActionColumn = dataGridCell.columnName == 'Acciones';
        bool isEstadoColumn = dataGridCell.columnName == 'Estado';

        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: isActionColumn
              ? dataGridCell.value
              : isEstadoColumn
                  ? CheckboxToTable(isChecked: dataGridCell.value as bool)
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