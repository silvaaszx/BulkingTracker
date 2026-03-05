import 'package:flutter/material.dart';
import 'package:bulkingtracker/core/theme/app_theme.dart'; // Importando o arquivo do tema
import 'package:bulkingtracker/features/dashboard/presentation/dashboard_screen.dart'; // Importando a tela de dashboard

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BulkingTracker',
      theme: AppTheme.darkTheme, // Chamando nosso tema personalizado aqui
      themeMode: ThemeMode.dark, // Forçando o Dark Mode
      home: const DashboardScreen(),
    );
  }
}
