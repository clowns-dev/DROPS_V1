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

  @override
  void initState() {
    super.initState();
    selectedId = widget.selectedId;
  }

  void _handleCheckboxChanged(int id) {
    setState(() {
      selectedId = id; // Actualizar el ID seleccionado
    });
    widget.onAssign(id); // Llamar la función de asignación para manejar el ID seleccionado
  }

  @override
  Widget build(BuildContext context) {
    final therapyDataSource = TherapyNursesDataSource(
      therapyNurses: widget.therapyNurses,
      onSelect: _handleCheckboxChanged,
      selectedId: selectedId,
    );

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
            source: therapyDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            gridLinesVisibility: GridLinesVisibility.none,
            headerGridLinesVisibility: GridLinesVisibility.none,
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
  final int? selectedId;

  @override
  List<DataGridRow> get rows => _nurses;

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

  void updateRowsPerPage(int rowsPerPage) {
    notifyListeners();
  }
}

