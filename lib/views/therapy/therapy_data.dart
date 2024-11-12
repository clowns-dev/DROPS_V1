import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

class TherapyDataTable extends StatefulWidget {
  final List<Therapy> therapies;
  final void Function(int id) onView;

  const TherapyDataTable({
    required this.therapies,
    required this.onView,
    super.key,
  });

  @override
  State<TherapyDataTable> createState() => _TherapyDataTableState();
}

class _TherapyDataTableState extends State<TherapyDataTable> {
  late TherapyDataSource _therapyDataSource;

  @override
  void initState() {
    super.initState();
    _therapyDataSource = TherapyDataSource(
      therapies: widget.therapies,
      onView: widget.onView,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SfDataGrid(
            source: _therapyDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            gridLinesVisibility: GridLinesVisibility.none,
            headerGridLinesVisibility: GridLinesVisibility.none,
            columns: <GridColumn>[
              GridColumn(
                columnName: 'idTherapy',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'ID Terapia',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'idNurse',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'CI Enfermera',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'idPatient',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'CI Paciente',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'stretcherNumber',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Nro. Cama',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'startDate',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Fecha Inicio asignación',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'finishDate',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Fecha Fin asignación',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
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
          delegate: _therapyDataSource,
          availableRowsPerPage: const <int>[5, 10, 15],
          pageCount: (widget.therapies.length / 10),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _therapyDataSource.updateRowsPerPage(rowsPerPage!);
            });
          },
        ),
      ],
    );
  }
}

class TherapyDataSource extends DataGridSource {
  TherapyDataSource({
    required List<Therapy> therapies,
    required this.onView,
  }) {
    _therapies = therapies.map<DataGridRow>((therapy) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'idTherapy', value: therapy.idTherapy),
        DataGridCell<int>(columnName: 'idNurse', value: therapy.idNurse),
        DataGridCell<int>(columnName: 'idPatient', value: therapy.idPatient),
        DataGridCell<int>(columnName: 'stretcherNumber', value: therapy.stretcherNumber),
        DataGridCell<String>(
          columnName: 'startDate',
          value: DateFormat('yyyy-MM-dd').format(therapy.startDate!),
        ),
        DataGridCell<String>(
          columnName: 'finishDate',
          value: DateFormat('yyyy-MM-dd').format(therapy.finishDate!),
        ),
        DataGridCell<Widget>(
          columnName: 'Acciones',
          value: ElevatedButton(
            onPressed: () => onView(therapy.idTherapy!),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDABFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.remove_red_eye,
                  size: 16.0,
                  color: Colors.white,
                ),
                SizedBox(width: 6.0),
                Text(
                  'Ver',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]);
    }).toList();
  }

  List<DataGridRow> _therapies = [];
  final void Function(int id) onView;

  @override
  List<DataGridRow> get rows => _therapies;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
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
  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

