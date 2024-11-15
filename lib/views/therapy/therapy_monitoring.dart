import 'package:flutter/material.dart';

class TherapyMonitoring extends StatelessWidget {
  final List<MonitorData> monitorData = [
    MonitorData(bed: "1", level: "10%", status: "LOW LEVEL!", color: Colors.red, patientName: "Jorge Gonzales Martínez"),
    MonitorData(bed: "3", level: "85%", status: "BUBBLE ALERT!", color: Colors.blue, patientName: "Fernanda López García"),
    MonitorData(bed: "5", level: "85%", status: "BLOCKAGE ALERT!", color: Colors.red, patientName: "Antonio Rodríguez Pérez"),
    MonitorData(bed: "7", level: "25%", status: "", color: Colors.green, patientName: "Andrés Navarro Silva"),
    MonitorData(bed: "15", level: "50%", status: "", color: Colors.green, patientName: "Alberto Ramírez Díaz"),
    MonitorData(bed: "11", level: "63%", status: "", color: Colors.green, patientName: "Carlos Gómez Sánchez"),
    MonitorData(bed: "10", level: "40%", status: "", color: Colors.green, patientName: "Sofía Vega Hernández"),
    MonitorData(bed: "4", level: "75%", status: "", color: Colors.green, patientName: "Ángel Castro Romero"),
    MonitorData(bed: "6", level: "90%", status: "", color: Colors.green, patientName: "Daniela Vargas Castillo"),
    MonitorData(bed: "12", level: "92%", status: "", color: Colors.green, patientName: "Eduardo Morales Ríos"),
    MonitorData(bed: "14", level: "89%", status: "", color: Colors.green, patientName: "Alejandra Ortega Cruz"),
    MonitorData(bed: "17", level: "80%", status: "", color: Colors.green, patientName: "Isabel Rivera González"),
  ];

  TherapyMonitoring({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoreo de Terapias'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: monitorData.length,
          itemBuilder: (context, index) {
            final data = monitorData[index];
            return MonitorCard(data: data);
          },
        ),
      ),
    );
  }
}

class MonitorCard extends StatelessWidget {
  final MonitorData data;

  const MonitorCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bed: ${data.bed}',
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: int.parse(data.level.replaceAll("%", "")) / 100,
                  strokeWidth: 6.0,
                  valueColor: AlwaysStoppedAnimation<Color>(data.color),
                  backgroundColor: Colors.grey.shade300,
                ),
                Text(
                  data.level,
                  style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            if (data.status.isNotEmpty)
              Text(
                data.status,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: data.color),
              ),
            const SizedBox(height: 8.0),
            Text(
              data.patientName,
              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class MonitorData {
  final String bed;
  final String level;
  final String status;
  final Color color;
  final String patientName;

  MonitorData({
    required this.bed,
    required this.level,
    required this.status,
    required this.color,
    required this.patientName,
  });
}