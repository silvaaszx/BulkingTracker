import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../tracking/providers/tracker_provider.dart';
import '../main/presentation/main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  
  // Variáveis para guardar o que o utilizador vai escrevendo
  String _name = '';
  double _currentWeight = 0.0;
  double _goalWeight = 0.0;

  // Função para guardar tudo e ir para a Home
  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true); // Marca que já fez o onboarding

    if (mounted) {
      final tracker = context.read<TrackerProvider>();
      final finalName = _name.isEmpty ? 'Atleta' : _name;
      
      tracker.setProfile(finalName, _goalWeight);
      tracker.setStartingWeight(_currentWeight);
      tracker.calculateAndSaveMacros(_currentWeight);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Impede deslizar com o dedo (obriga a usar os botões)
        children: [
          _buildNameStep(),
          _buildWeightStep(),
        ],
      ),
    );
  }

  // --- PASSO 1: O NOME ---
  Widget _buildNameStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.fitness_center, size: 60, color: Colors.purpleAccent),
          const SizedBox(height: 24),
          const Text(
            'Bem-vindo ao\nBulkingTracker!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Como queres ser chamado?',
            style: TextStyle(fontSize: 18, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          TextField(
            onChanged: (value) => _name = value,
            decoration: InputDecoration(
              hintText: 'Digite seu nome',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              },
              child: const Text('Continuar', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  // --- PASSO 2: O PESO ---
  Widget _buildWeightStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.monitor_weight_outlined, size: 60, color: Colors.purpleAccent),
          const SizedBox(height: 24),
          const Text(
            'Quais são as tuas metas?',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => _currentWeight = double.tryParse(value) ?? 0.0,
            decoration: InputDecoration(
              labelText: 'Peso Atual (kg)',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => _goalWeight = double.tryParse(value) ?? 0.0,
            decoration: InputDecoration(
              labelText: 'Peso Alvo (kg)',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _finishOnboarding, // Chama a função que guarda e vai pra Home!
              child: const Text('Começar o Bulking! 🚀', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
