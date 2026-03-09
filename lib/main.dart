import 'package:flutter/material.dart';
import 'package:bulkingtracker/core/theme/app_theme.dart'; // Importando o arquivo do tema
import 'package:bulkingtracker/features/main/presentation/main_screen.dart'; // Importando a MainScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BulkingTracker',
      theme: AppTheme.darkTheme, // Chamando nosso tema personalizado aqui
      themeMode: ThemeMode.dark, // Forçando o Dark Mode
      home: const MainScreen(), // Usando a MainScreen com BottomNavigation
    );
  }
}
