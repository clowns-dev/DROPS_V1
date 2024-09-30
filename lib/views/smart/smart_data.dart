import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ps3_drops_v1/models/smart.dart';
import 'package:ps3_drops_v1/widgets/checkbox_to_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ps3_drops_v1/widgets/edit_button.dart';
import 'package:ps3_drops_v1/widgets/delete_button.dart';
import 'package:ps3_drops_v1/widgets/grid_column_builder.dart';

class SmartDataTable extends StatefulWidget {
  final List<Smart> smarts;
  final void Function(int id) onEdit;
  final void Function(int id) onDelete;

  const SmartDataTable({
    required this.smarts,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  State<SmartDataTable> createState() => _SmartDataTableState();
}

class _SmartDataTableState extends State<SmartDataTable> {
  late SmartDataSource _smartDataSource;

  @override
  void initState() {
    super.initState();
    _smartDataSource = SmartDataSource(
      smarts: widget.smarts,
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
            source: _smartDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            gridLinesVisibility: GridLinesVisibility.none,
            headerGridLinesVisibility: GridLinesVisibility.none,
            columns: <GridColumn>[
              buildGridColumn('Codigo RFID', 'Codigo RFID'),
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
          delegate: _smartDataSource,
          availableRowsPerPage: const <int>[5, 10, 15],
          pageCount: (widget.smarts.length / 10),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _smartDataSource.updateRowsPerPage(rowsPerPage!);
            });
          },
        ),
      ],
    );
  }
}

class SmartDataSource extends DataGridSource {
  SmartDataSource({
    required List<Smart> smarts,
    required this.onEdit,
    required this.onDelete,
  }) {
    _smarts = smarts.map<DataGridRow>((smart) {
      final formattedRegisterDate = smart.registerDate != null
          ? DateFormat('yyyy-MM-dd').format(smart.registerDate!)
          : 'Sin Registro';
      final formattedLastUpdate = smart.lastUpdate != null
          ? DateFormat('yyyy-MM-dd').format(smart.lastUpdate!)
          : 'Sin Cambios';

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: smart.idSmart),
        DataGridCell<String>(columnName: 'Codigo RFID', value: smart.codeRFID),
        DataGridCell<String>(columnName: 'Fecha de\nRegistro', value: formattedRegisterDate),
        DataGridCell<String>(columnName: 'Fecha de\nActualizacion', value: formattedLastUpdate),
        DataGridCell<bool>(columnName: 'Estado', value: smart.status == 1),
        DataGridCell<Widget>(
          columnName: 'Acciones',
          value: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EditButton(onPressed: () => onEdit(smart.idSmart!)),
              const SizedBox(width: 8),
              DeleteButton(onPressed: () => onDelete(smart.idSmart!)),
            ],
          ),
        ),
      ]);
    }).toList();
  }

  List<DataGridRow> _smarts = [];
  final void Function(int id) onEdit;
  final void Function(int id) onDelete;

  @override
  List<DataGridRow> get rows => _smarts;

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

