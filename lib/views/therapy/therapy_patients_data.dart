import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/widgets/grid_column_builder.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ps3_drops_v1/widgets/checkbox_to_table.dart';

class TherapyPatientsDataTable extends StatefulWidget {
  final List<Patient> therapyPatients;
  final int? selectedId; 
  final void Function(int id) onAssign; 

  const TherapyPatientsDataTable({
    required this.therapyPatients,
    required this.selectedId, 
    required this.onAssign, 
    super.key,
  });

  @override
  State<TherapyPatientsDataTable> createState() => _TherapyPatientsDataTableState();
}

class _TherapyPatientsDataTableState extends State<TherapyPatientsDataTable> {
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
    final therapyDataSource = TherapyPatientsDataSource(
      therapyPatients: widget.therapyPatients,
      onSelect: _handleCheckboxChanged,
      selectedId: selectedId,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Pacientes',
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
              buildGridColumn('Paciente', 'Paciente'),
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
      ],
    );
  }
}


class TherapyPatientsDataSource extends DataGridSource {
  TherapyPatientsDataSource({
    required List<Patient> therapyPatients,
    required this.onSelect,
    this.selectedId,
  }) {
    _therapies = therapyPatients.map<DataGridRow>((therapy) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID', value: therapy.idPerson),
        DataGridCell<String>(columnName: 'Paciente', value: therapy.patient),
        DataGridCell<String>(columnName: 'CI', value: therapy.ci),
        DataGridCell<Widget>(
          columnName: 'Asignar',
          value: CheckboxToTable(
            isChecked: therapy.idPerson == selectedId,
            onChanged: () {
              onSelect(therapy.idPerson!);
            },
          ),
        ),


      ]);
    }).toList();
  }

  List<DataGridRow> _therapies = [];
  final void Function(int id) onSelect;
  final int? selectedId;

  @override
  List<DataGridRow> get rows => _therapies;

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

