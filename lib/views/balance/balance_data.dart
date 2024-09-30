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
  late BalanceDataSource _patientDataSource;

  @override
  void initState() {
    super.initState();
    _patientDataSource = BalanceDataSource(
      balances: widget.balances,
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
          delegate: _patientDataSource,
          availableRowsPerPage: const <int>[5, 10, 15],
          pageCount: (widget.balances.length / 10),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _patientDataSource.updateRowsPerPage(rowsPerPage!);
            });
          },
        ),
      ],
    );
  }
}

class BalanceDataSource extends DataGridSource {
  BalanceDataSource({
    required List<Balance> balances,
    required this.onEdit,
    required this.onDelete,
  }) {
    _balances = balances.map<DataGridRow>((balance) {
      final formattedRegisterDate = balance.registerDate != null
          ? DateFormat('yyyy-MM-dd').format(balance.registerDate!)
          : 'Sin Registro';
      final formattedLastUpdate = balance.lastUpdate != null
          ? DateFormat('yyyy-MM-dd').format(balance.lastUpdate!)
          : 'Sin Cambios';

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: balance.idBalance),
        DataGridCell<String>(columnName: 'Codigo', value: balance.balanceCode),
        DataGridCell<String>(columnName: 'Factor de\nCalibracion', value: balance.actuallyFactor.toString()),
        DataGridCell<String>(columnName: 'Fecha de\nRegistro', value: formattedRegisterDate),
        DataGridCell<String>(columnName: 'Fecha de\nActualizacion', value: formattedLastUpdate),
        DataGridCell<bool>(columnName: 'Estado', value: balance.status == 1),
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

  List<DataGridRow> _balances = [];
  final void Function(int id) onEdit;
  final void Function(int id) onDelete;

  @override
  List<DataGridRow> get rows => _balances;

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


  void updateRowsPerPage(int rowsPerPage) {
    notifyListeners();
  }
}

