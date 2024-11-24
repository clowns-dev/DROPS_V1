import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/tools/session_manager.dart';
import 'package:ps3_drops_v1/views/balance/balance_calibration.dart';
import 'package:ps3_drops_v1/views/balance/balance_index.dart';
import 'package:ps3_drops_v1/views/patient/patient_index.dart';
import 'package:ps3_drops_v1/views/smart/smart_index.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_index.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_monitoring.dart';
import 'package:ps3_drops_v1/views/users/login_view.dart';
import 'package:ps3_drops_v1/views/users/user_index.dart';
import 'package:ps3_drops_v1/widgets/title_nabvar_menu.dart';
import '../widgets/adaptive_scaffold.dart';

class HomePage extends StatefulWidget {
  final int role;
  const HomePage({super.key, required this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;

  List<AdaptiveScaffoldDestination> get destinations {
    if(widget.role == 1){
      return const [
        AdaptiveScaffoldDestination(title: 'Inicio', icon: Icons.home),
        AdaptiveScaffoldDestination(title: 'Balanzas', icon: Icons.medical_services),
        AdaptiveScaffoldDestination(title: 'Manillas', icon: Icons.watch),
        AdaptiveScaffoldDestination(title: 'Usuarios', icon: Icons.people),
        AdaptiveScaffoldDestination(title: 'Pacientes', icon: Icons.elderly),
        AdaptiveScaffoldDestination(title: 'Terapias', icon: Icons.healing),
        AdaptiveScaffoldDestination(title: 'Salir', icon: Icons.exit_to_app),
      ];
    } else if(widget.role == 2){
      return const [
        AdaptiveScaffoldDestination(title: 'Terapias Asignadas', icon: Icons.healing),
        AdaptiveScaffoldDestination(title: 'Salir', icon: Icons.exit_to_app),
      ];
    } else if(widget.role == 3){
      return const [
        AdaptiveScaffoldDestination(title: 'Calibracion Balanza', icon: Icons.medical_services),
        AdaptiveScaffoldDestination(title: 'Salir', icon: Icons.exit_to_app),
      ];
    } else {
      return const [
        AdaptiveScaffoldDestination(title: 'Salir', icon: Icons.exit_to_app),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    double avatarRadius;
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 960) {
      avatarRadius = 40.0; // Pantallas grandes
    } else if (screenWidth > 640) {
      avatarRadius = 26.5; // Pantallas medianas
    } else {
      avatarRadius = 23.5; // Pantallas pequeñas
    }

    return AdaptiveScaffold(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: avatarRadius, // Usamos el tamaño dinámico aquí
            backgroundImage: const NetworkImage(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/1142fcff92d25dcb717e3a64262ae9d27f8f226e327e4a1eb7d99f9e8a18f069?placeholderIfAbsent=true&apiKey=18be90e047eb4a8186c0c0147fe2e633',
            ),
          ),
          const SizedBox(width: 8),
          const TitleNabvarMenu(text: 'DROPS'),
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
      case 'Terapias Asignadas':
        return TherapyMonitoring();
      case 'Calibracion Balanza':
        return const BalanceCalibration();
      case 'Salir':
        sessionManager.token = null;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        });
        return const SizedBox.shrink();
      default:
        return const Center(child: Text('Opciones de página no disponible'));
    }
  }
}