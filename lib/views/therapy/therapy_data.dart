import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/widgets/view_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ps3_drops_v1/widgets/grid_column_builder.dart';

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
  int rowsPerPage = 5;
  @override
  void initState() {
    super.initState();
    _therapyDataSource = TherapyDataSource(
      therapies: widget.therapies,
      onView: widget.onView,
    );
  }

  @override
  void didUpdateWidget(covariant TherapyDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.therapies != widget.therapies) {
      _therapyDataSource.updateDataSource(widget.therapies);
    }
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
            rowsPerPage: _therapyDataSource.rowsPerPage,
            rowHeight: 50,
            columns: <GridColumn>[
              buildGridColumn('ID\nTerapia', 'ID\nTerapia'),
              buildGridColumn('CI\nEnfermer@', 'CI\nEnfermer@'),
              buildGridColumn('CI\nPaciente', 'CI\nPaciente'),
              buildGridColumn('Nro.\nCama', 'Nro.\nCama'),
              buildGridColumn('Fecha Inicio\nAsignacion', 'Fecha Inicio\nAsignacion'),
              buildGridColumn('Fecha Fin\nAsignacion', 'Fecha Fin\nAsignacion'),
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
          availableRowsPerPage: const <int>[5, 10],
          pageCount: (widget.therapies.length / _therapyDataSource.rowsPerPage).ceil().toDouble(),
          onRowsPerPageChanged: (int? rowsPerPage) {
            setState(() {
              _therapyDataSource.updateRowsPerPage(rowsPerPage!);
            });
          },
          onPageNavigationEnd: (int pageIndex) {
            setState(() {
              _therapyDataSource.updatePage(pageIndex, _therapyDataSource.rowsPerPage);
            });
          },
        ),
      ],
    );
  }
}

class TherapyDataSource extends DataGridSource {
  int rowsPerPage = 5; 
  int currentPageIndex = 0; 
  
  List<DataGridRow> _therapies = []; 
  
  final void Function(int id) onView; 

  TherapyDataSource({
    required List<Therapy> therapies,
    required this.onView,
  }) {
    _buildDataGridRows(therapies);
  }

  void _buildDataGridRows(List<Therapy> therapies){
    _therapies = therapies.map<DataGridRow>((therapy) {
      final formattedStartDate = therapy.startDate != null
          ? DateFormat('yyyy-MM-dd').format(therapy.startDate!)
          : 'No Iniciado';
      final formattedFinishDate = therapy.finishDate != null
          ? DateFormat('yyyy-MM-dd').format(therapy.finishDate!)
          : 'Sin fecha de Fin';

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'ID\nTerapia', value: therapy.idTherapy),
        DataGridCell<String>(columnName: 'CI\nEnfermer@', value: therapy.ciNurse ?? 'N/A'),
        DataGridCell<String>(columnName: 'CI\nPaciente', value: therapy.ciPatient ?? 'N/A'),
        DataGridCell<String>(columnName: 'Nro.\nCama', value: therapy.stretcherNumber ?? 'N/A'),
        DataGridCell<String>(columnName: 'Fecha Inicio\nAsignacion', value: formattedStartDate),
        DataGridCell<String>(columnName: 'Fecha Fin\nAsignacion', value: formattedFinishDate),
        DataGridCell<Widget>(
          columnName: 'Acciones',
          value: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ViewButton(onPressed: () => onView(therapy.idTherapy!)),
            ],
          ),
        ),
      ]);
    }).toList();
  }

  void updateDataSource(List<Therapy> therapies) {
    _buildDataGridRows(therapies);  
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
    endIndex = endIndex > _therapies.length ? _therapies.length : endIndex;
    return _therapies.sublist(startIndex, endIndex);
  }

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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
        );
      }).toList(),
    );
  }
}