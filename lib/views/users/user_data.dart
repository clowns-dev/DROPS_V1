import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/user.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ps3_drops_v1/widgets/edit_button.dart';
import 'package:ps3_drops_v1/widgets/delete_button.dart';
import 'package:ps3_drops_v1/widgets/grid_column_builder.dart';
import 'package:intl/intl.dart';

class UserDataTable extends StatefulWidget {
  final List<User> users;
  final void Function(int id) onEdit;
  final void Function(int id) onDelete;

  const UserDataTable({
    required this.users,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  State<UserDataTable> createState() => _UserDataTableState();
}

class _UserDataTableState extends State<UserDataTable> {
  late UserDataSource _userDataSource;
  int rowsPerPage = 5;
  @override
  void initState() {
    super.initState();
    _userDataSource = UserDataSource(
      users: widget.users,
      onEdit: widget.onEdit,
      onDelete: widget.onDelete,
    );
  }

  @override
  void didUpdateWidget(covariant UserDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.users != widget.users) {
      _userDataSource.updateDataSource(widget.users);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SfDataGrid(
            source: _userDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            gridLinesVisibility: GridLinesVisibility.none,
            headerGridLinesVisibility: GridLinesVisibility.none,
            rowsPerPage: _userDataSource.rowsPerPage,
            rowHeight: 50,
            columns: <GridColumn>[
              buildGridColumn('CI', 'CI'),
              buildGridColumn('Nombre', 'Nombre'),
              buildGridColumn('Apellido\nPaterno', 'Apellido\nPaterno'),
              buildGridColumn('Apellido\nMaterno', 'Apellido\nMaterno'),
              buildGridColumn('Telefono', 'Telefono'),
              buildGridColumn('Correo', 'Correo'),
              buildGridColumn('Fecha de\nRegistro', 'Fecha de\nRegistro'),
              buildGridColumn('Rol Usuario', 'Rol Usuario'),
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
          delegate: _userDataSource,
          availableRowsPerPage: const <int>[5, 10],
          pageCount: (widget.users.length / _userDataSource.rowsPerPage).ceil().toDouble(),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _userDataSource.updateRowsPerPage(rowsPerPage!);
            });
          },
          onPageNavigationEnd: (int pageIndex) {
            setState(() {
              _userDataSource.updatePage(pageIndex, _userDataSource.rowsPerPage);
            });
          },
        ),
      ],
    );
  }
}

class UserDataSource extends DataGridSource {
  int rowsPerPage = 5;
  int currentPageIndex = 0;
  List<DataGridRow> _users = [];

  final void Function(int id) onEdit;
  final void Function(int id) onDelete;

  UserDataSource({
    required List<User> users,
    required this.onEdit,
    required this.onDelete,
  }) {
    _buildDataGridRows(users);
  }

  void _buildDataGridRows(List<User> users){
    _users = users.map<DataGridRow>((user) {
      final formattedDate = user.registerDate != null
          ? DateFormat('yyyy-MM-dd').format(user.registerDate!)
          : 'No registrado';

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: user.idUser),
        DataGridCell<String>(columnName: 'CI', value: user.ci),
        DataGridCell<String>(columnName: 'Nombre', value: user.name),
        DataGridCell<String>(columnName: 'Apellido\nPaterno', value: user.lastName),
        DataGridCell<String>(columnName: 'Apellido\nMaterno', value: user.secondLastName),
        DataGridCell<String>(columnName: 'Telefono', value: user.phone),
        DataGridCell<String>(columnName: 'Correo', value: user.email),
        DataGridCell<String>(columnName: 'Fecha de Registro', value: formattedDate),
        DataGridCell<String>(columnName: 'Rol Usuario', value: user.nameRole ?? 'No asignado'),
        DataGridCell<Widget>(
          columnName: 'Acciones',
          value: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EditButton(onPressed: () => onEdit(user.idUser!)),
              const SizedBox(width: 8),
              DeleteButton(onPressed: () => onDelete(user.idUser!)),
            ],
          ),
        ),
      ]);
    }).toList();
  }

  void updateDataSource(List<User> users){
    _buildDataGridRows(users);
    notifyListeners();
  }

  void updatePage(int pageIndex, int rowsPerPage){
    currentPageIndex = pageIndex;
    this.rowsPerPage = rowsPerPage;
    notifyListeners();
  }

  void updateRowsPerPage(int rowsPerPage){
    this.rowsPerPage = rowsPerPage;
    currentPageIndex = 0;
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows {
    int startIndex = currentPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    endIndex = endIndex > _users.length ? _users.length : endIndex;
    return _users.sublist(startIndex, endIndex);
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().where((dataGridCell) {
        return dataGridCell.columnName != 'ID';
      }).map<Widget>((dataGridCell) {
        bool isActionColumn = dataGridCell.columnName == 'Acciones';
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
