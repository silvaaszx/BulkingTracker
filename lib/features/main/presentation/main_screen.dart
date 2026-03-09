import 'package:flutter/material.dart';
import 'package:bulkingtracker/features/dashboard/presentation/dashboard_screen.dart'; // Import da Dashboard
import 'package:bulkingtracker/features/dashboard/presentation/achievements_screen.dart'; // Import das Conquistas
import 'package:bulkingtracker/features/progress/presentation/progress_screen.dart';
import 'package:bulkingtracker/features/profile/presentation/profile_screen.dart'; // Import do Perfil

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Agora temos 4 telas na nossa lista
  final List<Widget> _screens = [
    const DashboardScreen(), 
    const ProgressScreen(), // <-- A mágica do gráfico entra aqui!
    const AchievementsScreen(), 
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], 
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary, // Nosso roxo
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed, // Super importante para caber 4 itens sem bugar o layout
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            activeIcon: Icon(Icons.show_chart),
            label: 'Evolução',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined), // Ícone de troféu vazado
            activeIcon: Icon(Icons.emoji_events), // Ícone de troféu preenchido
            label: 'Conquistas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
