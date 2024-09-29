import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/view_models/employee_view_model.dart';
import 'package:ps3_drops_v1/views/home_view.dart';
import 'package:ps3_drops_v1/view_models/patient_view_model.dart'; // Importa tu ViewModel

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientViewModel()), 
        ChangeNotifierProvider(create: (_) => EmployeeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PS3 Drops',
      debugShowCheckedModeBanner: false,
      home: HomePage(), // Llama a la HomePage que se utilizará para navegar
    );
  }
}
