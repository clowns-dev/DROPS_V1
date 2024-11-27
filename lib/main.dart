import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ps3_drops_v1/view_models/balance_view_model.dart';
import 'package:ps3_drops_v1/view_models/maintenance_view_model.dart';
import 'package:ps3_drops_v1/view_models/user_view_model.dart';
import 'package:ps3_drops_v1/view_models/smart_view_model.dart';
import 'package:ps3_drops_v1/view_models/therapy_view_model.dart';
import 'package:ps3_drops_v1/view_models/patient_view_model.dart';
import 'package:ps3_drops_v1/views/users/login_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => TherapyViewModel()),
        ChangeNotifierProvider(create: (_) => SmartViewModel()),
        ChangeNotifierProvider(create: (_) => BalanceViewModel()),
        ChangeNotifierProvider(create: (_) => MaintenanceViewModel())
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
      localizationsDelegates:  [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, 
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales:  [
        Locale('es', 'ES'), 
        Locale('en', 'US'), 
      ],
      locale:  Locale('es', 'ES'), 
      home:  LoginView(),
    );
  }
}
