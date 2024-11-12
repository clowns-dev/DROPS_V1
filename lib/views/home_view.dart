import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ps3_drops_v1/views/balance/balance_index.dart';
import 'package:ps3_drops_v1/views/patient/patient_index.dart';
import 'package:ps3_drops_v1/views/smart/smart_index.dart';
import 'package:ps3_drops_v1/views/users/user_index.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_index.dart';
import 'package:ps3_drops_v1/views/Biomedical/calibration_screen.dart';
import 'package:ps3_drops_v1/views/therapy/monitoring.dart'; // Importa la nueva pantalla de monitoreo
import '../widgets/adaptive_scaffold.dart';
import '../widgets/title_nabvar_menu.dart';

class HomePage extends StatefulWidget {
  final String role;

  const HomePage({super.key, required this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;

  List<AdaptiveScaffoldDestination> get destinations {
    // Configura las opciones de navegación en función del rol del usuario
    if (widget.role == 'Administrador') {
      return const [
        AdaptiveScaffoldDestination(title: 'Inicio', icon: Icons.home),
        AdaptiveScaffoldDestination(title: 'Balanzas', icon: Icons.medical_services),
        AdaptiveScaffoldDestination(title: 'Manillas', icon: Icons.watch),
        AdaptiveScaffoldDestination(title: 'Usuarios', icon: Icons.people),
        AdaptiveScaffoldDestination(title: 'Pacientes', icon: Icons.elderly),
        AdaptiveScaffoldDestination(title: 'Terapias', icon: Icons.healing),
        AdaptiveScaffoldDestination(title: 'Monitoreo', icon: Icons.monitor_heart),
        AdaptiveScaffoldDestination(title: 'Biomedicos', icon: Icons.healing),
        AdaptiveScaffoldDestination(title: 'Salir', icon: Icons.exit_to_app),
      ];
    } else if (widget.role == 'Enfermera') {
      return const [
        AdaptiveScaffoldDestination(title: 'Inicio', icon: Icons.home),
        AdaptiveScaffoldDestination(title: 'Pacientes', icon: Icons.elderly),
        AdaptiveScaffoldDestination(title: 'Terapias', icon: Icons.healing),
        AdaptiveScaffoldDestination(title: 'Monitoreo', icon: Icons.monitor_heart),
        AdaptiveScaffoldDestination(title: 'Salir', icon: Icons.exit_to_app),
      ];
    } else if (widget.role == 'Biomedico') {
      return const [
        AdaptiveScaffoldDestination(title: 'Inicio', icon: Icons.home),
        AdaptiveScaffoldDestination(title: 'Balanzas', icon: Icons.medical_services),
        AdaptiveScaffoldDestination(title: 'Manillas', icon: Icons.watch),
        AdaptiveScaffoldDestination(title: 'Biomedicos', icon: Icons.healing),
        AdaptiveScaffoldDestination(title: 'Salir', icon: Icons.exit_to_app),
      ];
    } else {
      // Si el rol no es reconocido, muestra una página de error o salida
      return const [
        AdaptiveScaffoldDestination(title: 'Salir', icon: Icons.exit_to_app),
      ];
    }
  }

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
          SizedBox(
            width: 4,
          ),
          TitleNabvarMenu(text: 'DROPS'),
        ],
      ),
      currentIndex: _pageIndex,
      destinations: destinations,
      body: _pageAtIndex(_pageIndex),
      onNavigationIndexChange: (newIndex) {
        setState(() {
          _pageIndex = newIndex;
        });
      },
    );
  }

  Widget _pageAtIndex(int index) {
    // Obtiene el destino real según el índice y el rol del usuario
    final filteredDestinations = destinations;

    if (index >= filteredDestinations.length) {
      return const Center(child: Text('Página no disponible'));
    }

    final selectedDestination = filteredDestinations[index].title;

    switch (selectedDestination) {
      case 'Inicio':
        return const Text("Pagina 1");
      case 'Balanzas':
        return const BalanceIndex();
      case 'Manillas':
        return const SmartIndex();
      case 'Usuarios':
        return const UserIndex();
      case 'Pacientes':
        return const PatientIndex();
      case 'Terapias':
        return const TherapyIndex();
      case 'Monitoreo':
        return MonitoringView();
      case 'Biomedicos':
        return CalibrationScreen();
      case 'Salir':
        SystemNavigator.pop(); // Cierra la aplicación
        return const SizedBox.shrink(); // Una página vacía mientras se cierra
      default:
        return const Center(child: Text('Opciones de página no disponible'));
    }
  }
}
