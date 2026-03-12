import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tracking/providers/tracker_provider.dart';
import '../../tracking/services/gemini_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<TrackerProvider>();

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
              const SizedBox(height: 40),
              Text(
                'Fala, ${tracker.userName}!',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Bora bater as metas de hoje?',
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
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
    // Chamando o nosso Provider para ouvir as mudanças!
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
              const Text(
                'Calorias',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                // Injetando os dados reais aqui!
                '${tracker.currentKcal} / ${tracker.goalKcal} kcal',
                style: const TextStyle(fontSize: 16),
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
                  value: tracker.kcalProgress, // Porcentagem real!
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[800],
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text(
                // Calculando a porcentagem pra exibir no meio do círculo
                '${(tracker.kcalProgress * 100).toInt()}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
 
  Widget _buildMacrosGrid(BuildContext context) {
    final tracker = context.watch<TrackerProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMacroCard(
          context,
          'Proteína',
          '${tracker.currentProtein}g',
          'Faltam ${tracker.goalProtein - tracker.currentProtein}g',
          tracker.proteinProgress,
          Colors.blueAccent,
        ),
        _buildMacroCard(
          context,
          'Carbo',
          '${tracker.currentCarbo}g',
          'Faltam ${tracker.goalCarbo - tracker.currentCarbo}g',
          tracker.carboProgress,
          Theme.of(context).colorScheme.primary,
        ),
        _buildMacroCard(
          context,
          'Gordura',
          '${tracker.currentFat}g',
          'Faltam ${tracker.goalFat - tracker.currentFat}g',
          tracker.fatProgress,
          Colors.orangeAccent,
        ),
      ],
    );
  }

  // Adicionamos o "double progress" aqui na assinatura do método
  Widget _buildMacroCard(BuildContext context, String title, String value, String subtitle, double progress, Color color) {
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
              value: progress, // E colocamos a variável dinâmica aqui!
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
              Text(
                'Rumo aos ${tracker.goalWeight}kg', // <-- Meta real
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Peso atual: ${tracker.currentWeight}kg', // <-- Peso real
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.monitor_weight_outlined, color: Theme.of(context).colorScheme.primary),
          ),
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
    final TextEditingController mealController = TextEditingController();
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
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
                      Icon(Icons.auto_awesome, color: Colors.amber),
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

                  TextField(
                    controller: mealController,
                    maxLines: 3,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      hintText: 'Ex: Comi 150g de arroz branco, 100g de frango grelhado...',
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
                      onPressed: isLoading ? null : () async {
                        final text = mealController.text.trim();
                        if (text.isEmpty) return;

                        setModalState(() { isLoading = true; });

                        final service = GeminiService();
                        final result = await service.analyzeMeal(text);

                        setModalState(() { isLoading = false; });

                        if (result != null) {
                          // Usamos bottomSheetContext para acessar o provider no escopo correto
                          bottomSheetContext.read<TrackerProvider>().addMealMacros(
                            kcal: result['kcal']!,
                            protein: result['protein']!,
                            carbo: result['carbo']!,
                            fat: result['fat']!,
                          );

                          Navigator.pop(bottomSheetContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Refeição analisada e adicionada! 🚀'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ops! A IA não conseguiu entender. Tente detalhar mais.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      icon: isLoading
                          ? const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.analytics_outlined, color: Colors.white),
                      label: Text(
                        isLoading ? 'Analisando...' : 'Analisar com IA',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
        );
      },
    );
  }
}