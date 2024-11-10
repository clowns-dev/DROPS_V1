import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ps3_drops_v1/views/balance/balance_index.dart';
import 'package:ps3_drops_v1/views/patient/patient_index.dart';
import 'package:ps3_drops_v1/views/smart/smart_index.dart';
import 'package:ps3_drops_v1/views/therapy/therapy_index.dart';
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
      destinations: const [
        AdaptiveScaffoldDestination(title: 'Inicio', icon: Icons.home),
        AdaptiveScaffoldDestination(title: 'Balanzas', icon: Icons.medical_services),
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
    if (index == 0) return const Text("Pagina 1");
    if (index == 1) return const BalanceIndex();
    if (index == 2) return const SmartIndex();
    if (index == 3) return const UserIndex();
    if (index == 4) return const PatientIndex();
    if (index == 5) return const TherapyIndex();
    if (index == 6) SystemNavigator.pop();

    return const Center(child: Text('Opciones de pagina'));
  }
}
