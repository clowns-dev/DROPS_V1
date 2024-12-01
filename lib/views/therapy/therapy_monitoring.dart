import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/models/therapy.dart';
import 'package:ps3_drops_v1/tools/session_manager.dart';
import 'package:ps3_drops_v1/view_models/therapy_view_model.dart';

class TherapyMonitoring extends StatefulWidget {
  const TherapyMonitoring({super.key});

  @override
  TherapyMonitoringState createState() => TherapyMonitoringState();
}

class TherapyMonitoringState extends State<TherapyMonitoring> {
  @override
  void initState() {
    super.initState();
    _loadTherapies();
  }

  void _loadTherapies() {
    final monitoringViewModel = context.read<TherapyViewModel>();
    monitoringViewModel.fetchAllInfoNurseTherapies(context, sessionManager.idUser!);
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoreo de Terapias'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTherapies,
          ),
        ],
      ),
      body: Consumer<TherapyViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.listNurseTherapies.isEmpty) {
            return const Center(child: Text('No hay datos disponibles'));
          }

          final sortedTherapies = [...viewModel.listNurseTherapies];
          sortedTherapies.sort((a, b) {
            int getAlertPriority(String? alert) {
              if (alert == null) return 999;
              if (alert.contains('Emergencia')) return 1;
              if (alert.contains('Nivel Bajo')) return 2;
              if (alert.contains('Bloqueo')) return 3;
              if (alert.contains('Burbuja')) return 4;
              return 999; 
            }

            return getAlertPriority(a.alert).compareTo(getAlertPriority(b.alert));
          });

          final crossAxisCount = (screenWidth ~/ 280).clamp(1, 4);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.85,
              ),
              itemCount: sortedTherapies.length,
              itemBuilder: (context, index) {
                final therapy = sortedTherapies[index];
                return MonitorCard(data: therapy);
              },
            ),
          );
        },
      ),
    );
  }
}

class MonitorCard extends StatelessWidget {
  final InfoTherapiesNurse data;

  const MonitorCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final double percentage = (data.samplePercentage ?? 0).toDouble();
    Color alertColor = data.alert != null && data.alert!.trim().contains('Bloqueo')
      ? const Color.fromARGB(255, 193, 209, 51)
      : data.alert!.trim().contains('Burbuja')
          ? Colors.blue
          : data.alert!.trim().contains('Nivel Bajo')
              ? Colors.orange
              : data.alert!.trim().contains('Emergencia')
                  ? const Color.fromARGB(255, 233, 26, 11)
                  : data.alert!.trim().contains('Estable')
                      ? Colors.green
                      : Colors.black;

    final progressIndicatorSize = MediaQuery.of(context).size.width / 6;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 8.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              alertColor.withOpacity(0.1),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Cama: ${data.stretcherNumber ?? "N/A"}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: alertColor,
                ),
              ),
              const SizedBox(height: 12.0),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: progressIndicatorSize,
                    height: progressIndicatorSize,
                    child: CircularProgressIndicator(
                      value: percentage / 100,
                      strokeWidth: 10.0,
                      valueColor: AlwaysStoppedAnimation<Color>(alertColor), 
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${data.samplePercentage ?? 0}%',
                        style: const TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (data.alert != null && data.alert!.isNotEmpty)
                        Text(
                          data.alert!,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: alertColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(
                data.patient ?? "Desconocido",
                style: const TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}