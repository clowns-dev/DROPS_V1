import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ps3_drops_v1/views/patient/patient_index.dart';
import 'package:ps3_drops_v1/views/users/user_index.dart';

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
            backgroundImage: NetworkImage('https://cdn.builder.io/api/v1/image/assets/TEMP/1142fcff92d25dcb717e3a64262ae9d27f8f226e327e4a1eb7d99f9e8a18f069?placeholderIfAbsent=true&apiKey=18be90e047eb4a8186c0c0147fe2e633'),
          ),

          SizedBox(width: 4,),

          Text(
            'Drops',
            style: TextStyle(
              fontFamily: 'Notable',
              fontSize: 28,
              fontWeight: FontWeight.w400,
            ),
          ),
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
      //floatingActionButton: _hasFloatingActionButton ? _buildFab(context) : null,
    );
  }

  bool get _hasFloatingActionButton{
      if (_pageIndex == 2) return false;
    return true;
  }

  FloatingActionButton _buildFab(BuildContext context){
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => {},
    );
  }
/*
  void _handleFabPressed(){
    if(_pageIndex == 0){
      showDialog<NewCategoryDialog>(
        context: context,
        builder: (context) => const NewCategoryDialog(),
      );
      return;
    }

    if(_pageIndex == 0){
      showDialog<NewEntryDialog>(
        context: context,
        builder: (context) => const NewEntryDialog(),
      );
      return;
    }
  }
  */
  static Widget _pageAtIndex(int index){
    
    if(index == 0){
      return const Text("Pagina 1");
    }

    if(index == 1){
      return const Text('pagina 2');
    }

    if(index == 2){
      return const Text('pagina 3');
    }

    if(index == 3){
    
      return const UsersPage();
    }

    if(index == 4){
      return const PatientIndex();
    }

    if(index == 5){
      return const Text('pagina 6');
    }

    if(index == 6){
      SystemNavigator.pop();
    }

    return const Center(child: Text('Opciones de pagina'));
  }
}