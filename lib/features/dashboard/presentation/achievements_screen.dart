import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../tracking/providers/tracker_provider.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<TrackerProvider>();

    final achievements = [
      {
        'title': 'Primeiro Passo', 
        'desc': 'Registrou a 1ª refeição', 
        'icon': Icons.restaurant, 
        'unlocked': tracker.currentKcal > 0
      },
      {
        'title': 'Monstro da Proteína', 
        'desc': 'Bateu a meta de proteína', 
        'icon': Icons.fitness_center, 
        'unlocked': tracker.currentProtein >= tracker.goalProtein
      },
      {
        'title': 'Hidratado', 
        'desc': 'Bebeu 3L de água', 
        'icon': Icons.water_drop, 
        'unlocked': tracker.waterIntake >= tracker.waterGoal
      },
      {
        'title': 'Foco no Bulking', 
        'desc': 'Bateu a meta de calorias', 
        'icon': Icons.local_fire_department, 
        'unlocked': tracker.currentKcal >= tracker.goalKcal 
      },
      {
        'title': 'Rumo à Meta', 
        'desc': 'Alcançou o peso alvo', 
        'icon': Icons.monitor_weight, 
        'unlocked': tracker.currentWeight >= tracker.goalWeight && tracker.goalWeight > 0 
      },
      {
        'title': 'Rei do Carbo', 
        'desc': 'Bateu a meta de carbo', 
        'icon': Icons.cookie, 
        'unlocked': tracker.currentCarbo >= tracker.goalCarbo
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F12),
      appBar: AppBar(
        title: const Text('Mural de Conquistas', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'Suas Vitórias',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ).animate().fade(duration: 400.ms).slideY(begin: 0.1),
              const SizedBox(height: 8),
              Text(
                'Desbloqueie troféus batendo suas metas diárias.',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
              ).animate().fade(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: List.generate(achievements.length, (index) {
                    final item = achievements[index];
                    final isUnlocked = item['unlocked'] as bool;

                    return _buildAchievementCard(
                      title: item['title'] as String,
                      desc: item['desc'] as String,
                      iconData: item['icon'] as IconData,
                      isUnlocked: isUnlocked,
                    ).animate(delay: (200 + (index * 100)).ms)
                     .fade(duration: 400.ms)
                     .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard({
    required String title,
    required String desc,
    required IconData iconData,
    required bool isUnlocked,
  }) {
    final glowColor = Colors.deepPurpleAccent;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161618),
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [Colors.grey.shade900, const Color(0xFF1A1A24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: isUnlocked ? [
          BoxShadow(
            color: glowColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ] : [],
        border: isUnlocked 
            ? Border.all(color: glowColor.withOpacity(0.8), width: 1.5) 
            : Border.all(color: Colors.white.withOpacity(0.02), width: 1),
      ),
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 42,
                color: isUnlocked ? glowColor : Colors.grey.shade600,
              ).animate(
                onPlay: isUnlocked ? (controller) => controller.repeat(reverse: true) : null,
              ).scaleXY(begin: 1.0, end: 1.08, duration: 1500.ms, curve: Curves.easeInOut),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isUnlocked ? Colors.white : Colors.grey.shade500,
                  shadows: isUnlocked ? [Shadow(color: glowColor.withOpacity(0.5), blurRadius: 10)] : [],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
              if (!isUnlocked) ...[
                const SizedBox(height: 8),
                Icon(Icons.lock, size: 20, color: Colors.grey[600]),
              ]
            ],
          ),
        ),
      ),
    );
  }
}