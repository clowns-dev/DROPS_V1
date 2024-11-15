import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ps3_drops_v1/views/balance/balance_index.dart';
import 'package:ps3_drops_v1/views/patient/patient_index.dart';
import 'package:ps3_drops_v1/views/smart/smart_index.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_records_view.dart'; // Asegúrate de importar therapy_records_view.dart
import 'package:ps3_drops_v1/views/users/user_index.dart';
import 'package:ps3_drops_v1/widgets/title_nabvar_menu.dart';
import '../widgets/adaptive_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 38.5,
            backgroundImage: NetworkImage(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/1142fcff92d25dcb717e3a64262ae9d27f8f226e327e4a1eb7d99f9e8a18f069?placeholderIfAbsent=true&apiKey=18be90e047eb4a8186c0c0147fe2e633'),
          ),
          SizedBox(width: 4),
          TitleNabvarMenu(text: 'DROPS')
        ],
      ),
      currentIndex: _pageIndex,
      destinations: const [
        AdaptiveScaffoldDestination(title: 'Inicio', icon: Icons.home),
        AdaptiveScaffoldDestination(
            title: 'Balanzas', icon: Icons.medical_services),
        AdaptiveScaffoldDestination(title: 'Manillas', icon: Icons.watch),
        AdaptiveScaffoldDestination(title: 'Usuarios', icon: Icons.people),
        AdaptiveScaffoldDestination(title: 'Pacientes', icon: Icons.elderly),
        AdaptiveScaffoldDestination(title: 'Terapias', icon: Icons.healing),
        AdaptiveScaffoldDestination(title: 'Salir', icon: Icons.exit_to_app),
      ],
      body: _pageAtIndex(_pageIndex),
      onNavigationIndexChange: (newIndex) {
        setState(() {
          _pageIndex = newIndex;
        });
      },
    );
  }

  static Widget _pageAtIndex(int index) {
    if (index == 0) {
      return const Text("Página de Inicio");
    }
    if (index == 1) {
      return const BalanceIndex();
    }
    if (index == 2) {
      return const SmartIndex();
    }
    if (index == 3) {
      return const UserIndex();
    }
    if (index == 4) {
      return const PatientIndex();
    }
    if (index == 5) {
      return TherapyRecordsView(); // Elimina el `const` aquí
    }
    if (index == 6) {
      SystemNavigator.pop();
    }

    return const Center(child: Text('Opciones de página'));
  }
}
