import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tracking/providers/tracker_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BulkingTracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fala, Matheus!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bora bater os macros de hoje?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 32),
              
              _buildProgressCard(context),
              const SizedBox(height: 24),
              _buildMacrosGrid(context),
              const SizedBox(height: 24),
              _buildWaterCard(context),
              const SizedBox(height: 24),
              _buildWeightGoalCard(context),
            ],
          ),
        ),
      ),
      // Nosso Botão Flutuante que tinha ficado de fora:
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMealBottomSheet(context),
        backgroundColor: Theme.of(context).colorScheme.primary, 
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nova Refeição', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calorias',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '2100 / 3200 kcal',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: 0.65, // 65% da meta batida
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[800],
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const Text(
                '65%',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMacrosGrid(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMacroCard(context, 'Proteína', '160g', 'Faltam 40g', Colors.blueAccent),
        _buildMacroCard(context, 'Carbo', '350g', 'Faltam 120g', Theme.of(context).colorScheme.primary),
        _buildMacroCard(context, 'Gordura', '80g', 'Faltam 15g', Colors.orangeAccent),
      ],
    );
  }

  Widget _buildMacroCard(BuildContext context, String title, String value, String subtitle, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.grey[800],
              color: color,
            ),
            const SizedBox(height: 8),
            Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightGoalCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rumo aos 70kg', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Peso atual: 52kg', style: TextStyle(fontSize: 14, color: Colors.grey[400])),
            ],
          ),
          Icon(Icons.monitor_weight_outlined, color: Theme.of(context).colorScheme.secondary, size: 32),
        ],
      ),
    );
  }

  Widget _buildWaterCard(BuildContext context) {
    final tracker = context.watch<TrackerProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.water_drop, color: Colors.blueAccent, size: 20),
                  SizedBox(width: 8),
                  Text('Água', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${tracker.waterIntake} / ${tracker.waterGoal} ml',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              // Barra de progresso da água
              SizedBox(
                width: 150,
                child: LinearProgressIndicator(
                  value: tracker.waterProgress,
                  backgroundColor: Colors.grey[800],
                  color: Colors.blueAccent,
                  minHeight: 8,
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              elevation: 0,
            ),
            onPressed: () {
              context.read<TrackerProvider>().addWater(250);
            },
            child: const Column(
              children: [
                Icon(Icons.add, color: Colors.blueAccent),
                Text('250ml', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // A função que abre o formulário
  void _showAddMealBottomSheet(BuildContext context) {
    // Controlador para pegar o texto que o usuário digitar
    final TextEditingController mealController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.amber), // Ícone de IA
                  SizedBox(width: 8),
                  Text(
                    'Descreva sua refeição',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Nossa IA vai calcular as calorias e macros automaticamente para você.',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
              const SizedBox(height: 24),

              // O campo de Texto Livre
              TextField(
                controller: mealController,
                maxLines: 3, // Deixa o campo mais altinho
                decoration: InputDecoration(
                  hintText: 'Ex: Comi 150g de arroz branco, 100g de frango grelhado e tomei um copo de suco de laranja...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    // Aqui vai entrar a chamada da API do Gemini depois!
                    // Por enquanto, vamos fingir que a IA calculou e vamos jogar dados fixos pra testar o Provider
                    context.read<TrackerProvider>().addMealMacros(
                      kcal: 450,
                      protein: 35,
                      carbo: 40,
                      fat: 10,
                    );
                    Navigator.pop(bottomSheetContext);
                  },
                  icon: const Icon(Icons.analytics_outlined, color: Colors.white),
                  label: const Text(
                    'Analisar com IA',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}