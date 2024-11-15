import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/view_models/therapy_view_model.dart';
import 'therapy_detail_view.dart';

class TherapyRecordsView extends StatelessWidget {
  const TherapyRecordsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registros de Terapias')),
      body: Consumer<TherapyViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.listTherapies.isEmpty) {
            return const Center(child: Text('No se encontraron terapias.'));
          }
          return ListView.builder(
            itemCount: viewModel.listTherapies.length,
            itemBuilder: (context, index) {
              final therapy = viewModel.listTherapies[index];
              return ListTile(
                title: Text('Terapia ID: ${therapy.idTherapy}'),
                subtitle: Text(
                    'Paciente ID: ${therapy.idPatient ?? 'N/A'}, Enfermero ID: ${therapy.idNurse ?? 'N/A'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TherapyDetailView(therapyId: therapy.idTherapy!),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
