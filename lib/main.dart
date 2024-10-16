import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/view_models/balance_view_model.dart';
import 'package:ps3_drops_v1/view_models/employee_view_model.dart';
import 'package:ps3_drops_v1/view_models/smart_view_model.dart';
import 'package:ps3_drops_v1/view_models/therapy_view_model.dart';
import 'package:ps3_drops_v1/views/home_view.dart';
import 'package:ps3_drops_v1/view_models/patient_view_model.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientViewModel()), 
        ChangeNotifierProvider(create: (_) => EmployeeViewModel()),
        ChangeNotifierProvider(create: (_) => TherapyViewModel()),
        ChangeNotifierProvider(create: (_) => SmartViewModel()),
        ChangeNotifierProvider(create: (_) => BalanceViewModel()),
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('es', 'ES'), // Español
        Locale('en', 'US'), // Inglés
      ],

      // Opcional: Puedes forzar que la aplicación inicie en un idioma específico
      locale: Locale('es', 'ES'), // Cambia a 'es' para que la aplicación inicie en español
      home: HomePage(),
    );
  }
}
