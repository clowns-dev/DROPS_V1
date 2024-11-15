import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TherapyDetailView extends StatelessWidget {
  final int therapyId;
  const TherapyDetailView({Key? key, required this.therapyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo
    final List<ChartData> chartData = [
      ChartData('Operativo', 70),
      ChartData('Interrupción', 15),
      ChartData('Bloqueo', 10),
      ChartData('Burbuja', 5),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Detalles de Terapia $therapyId')),
      body: Center(
        child: SfCircularChart(
          series: <CircularSeries>[
            PieSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
