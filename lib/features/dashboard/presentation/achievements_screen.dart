import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista mockada de conquistas para o visual do portfólio
    final achievements = [
      {'title': 'Primeiro Passo', 'desc': 'Registrou a 1ª refeição', 'icon': Icons.restaurant, 'unlocked': true},
      {'title': 'Monstro da Proteína', 'desc': 'Bateu a meta de proteína', 'icon': Icons.fitness_center, 'unlocked': true},
      {'title': 'Hidratado', 'desc': 'Bebeu 3L de água hoje', 'icon': Icons.water_drop, 'unlocked': false},
      {'title': '1 Semana no Foco', 'desc': '7 dias batendo as metas', 'icon': Icons.local_fire_department, 'unlocked': false},
      {'title': 'Rumo aos 60kg', 'desc': 'Alcançou 60kg na balança', 'icon': Icons.monitor_weight, 'unlocked': false},
      {'title': 'Mestre Cuca', 'desc': 'Registrou 50 refeições', 'icon': Icons.cookie, 'unlocked': false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mural de Conquistas', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        // Aqui configuramos o Grid para ter 2 colunas
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85, // Ajusta a altura dos cards
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final item = achievements[index];
          final isUnlocked = item['unlocked'] as bool;

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              // Adiciona uma borda roxa se a conquista estiver desbloqueada
              border: isUnlocked 
                  ? Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), width: 2) 
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['icon'] as IconData,
                  size: 48,
                  // Ícone roxo se desbloqueado, cinza se bloqueado
                  color: isUnlocked ? Theme.of(context).colorScheme.primary : Colors.grey[700],
                ),
                const SizedBox(height: 12),
                Text(
                  item['title'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isUnlocked ? Colors.white : Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    item['desc'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                // Se estiver bloqueado, mostra um cadeado pequeno embaixo
                if (!isUnlocked) ...[
                  const SizedBox(height: 12),
                  Icon(Icons.lock, size: 16, color: Colors.grey[600]),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}