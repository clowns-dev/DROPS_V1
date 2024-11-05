import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ps3_drops_v1/models/smart.dart';
import 'package:ps3_drops_v1/widgets/assignment_button.dart';
import 'package:ps3_drops_v1/widgets/checkbox_to_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ps3_drops_v1/widgets/edit_button.dart';
import 'package:ps3_drops_v1/widgets/delete_button.dart';
import 'package:ps3_drops_v1/widgets/grid_column_builder.dart';

class SmartDataTable extends StatefulWidget {
  final List<Smart> smarts;
  final void Function(int id) onEdit;
  final void Function(int id) onDelete;
  final void Function(int idSmart) onAssignment;

  const SmartDataTable({
    required this.smarts,
    required this.onEdit,
    required this.onDelete,
    required this.onAssignment,
    super.key,
  });

  @override
  State<SmartDataTable> createState() => _SmartDataTableState();
}

class _SmartDataTableState extends State<SmartDataTable> {
  late SmartDataSource _smartDataSource;
  int rowsPerPage = 5;
  @override
  void initState() {
    super.initState();
    _smartDataSource = SmartDataSource(
      smarts: widget.smarts,
      onEdit: widget.onEdit,
      onDelete: widget.onDelete,
      onAssignment: widget.onAssignment,
    );
  }

  @override
  void didUpdateWidget(covariant SmartDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.smarts != widget.smarts) {
      _smartDataSource.updateDataSource(widget.smarts);
    }
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
            rowsPerPage: _smartDataSource.rowsPerPage,
            rowHeight: 50,
            columns: <GridColumn>[
              buildGridColumn('Codigo RFID', 'Codigo RFID'),
              buildGridColumn('Enfermero\nAsignado', 'Enfermero\nAsignado'),
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
          availableRowsPerPage: const <int>[5, 10],
          pageCount: (widget.smarts.length / _smartDataSource.rowsPerPage).ceil().toDouble(),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _smartDataSource.updateRowsPerPage(rowsPerPage!);
            });
          },
          onPageNavigationEnd: (int pageIndex) {
            setState(() {
              _smartDataSource.updatePage(pageIndex, _smartDataSource.rowsPerPage);
            });
          },
        ),
      ],
    );
  }
}

class SmartDataSource extends DataGridSource {
  int rowsPerPage = 5;
  int currentPageIndex = 0;
  List<DataGridRow> _smarts = [];

  final void Function(int id) onEdit;
  final void Function(int id) onDelete;
  final void Function(int id) onAssignment;

  SmartDataSource({
    required List<Smart> smarts,
    required this.onEdit,
    required this.onDelete,
    required this.onAssignment,
  }) {
    _buildDataGridRows(smarts);
  }

  // Método para construir las filas del DataGrid
  void _buildDataGridRows(List<Smart> smarts) {
    _smarts = smarts.map<DataGridRow>((smart) {
      final formattedRegisterDate = smart.registerDate != null
          ? DateFormat('yyyy-MM-dd').format(smart.registerDate!)
          : 'Sin Registro';
      final formattedLastUpdate = smart.lastUpdate != null
          ? DateFormat('yyyy-MM-dd').format(smart.lastUpdate!)
          : 'Sin Cambios';

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: smart.idSmart),
        DataGridCell<int>(columnName: 'ID_User', value: smart.idUser),
        DataGridCell<String>(columnName: 'Codigo RFID', value: smart.codeRFID),
        DataGridCell<String>(columnName: 'Enfermero\nAsignado', value: smart.assingment),
        DataGridCell<String>(columnName: 'Fecha de\nRegistro', value: formattedRegisterDate),
        DataGridCell<String>(columnName: 'Fecha de\nActualizacion', value: formattedLastUpdate),
        DataGridCell<bool>(columnName: 'Estado', value: smart.available == 1),
        DataGridCell<Widget>(
          columnName: 'Acciones',
          value: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AssignmentButton(onPressed: () => onAssignment(smart.idSmart!)),
              const SizedBox(width: 8),
              EditButton(onPressed: () => onEdit(smart.idSmart!)),
              const SizedBox(width: 8),
              DeleteButton(onPressed: () => onDelete(smart.idSmart!)),
            ],
          ),
        ),
      ]);
    }).toList();
  }

  // Método para actualizar los datos en _smarts
  void updateDataSource(List<Smart> smarts) {
    _buildDataGridRows(smarts);  // Llama al método para reconstruir las filas
    notifyListeners();           // Notifica a la UI para refrescar
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
    endIndex = endIndex > _smarts.length ? _smarts.length : endIndex;
    return _smarts.sublist(startIndex, endIndex);
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().where((dataGridCell) {
        return dataGridCell.columnName != 'ID' && dataGridCell.columnName != 'ID_User';
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
