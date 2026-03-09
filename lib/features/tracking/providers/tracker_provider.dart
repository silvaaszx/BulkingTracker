import 'package:flutter/material.dart';

class TrackerProvider extends ChangeNotifier {
  // --- ÁGUA ---
  int _waterIntake = 0;
  final int _waterGoal = 3000;
  
  int get waterIntake => _waterIntake;
  int get waterGoal => _waterGoal;
  double get waterProgress => (_waterIntake / _waterGoal).clamp(0.0, 1.0);

  void addWater(int amount) {
    _waterIntake += amount;
    notifyListeners();
  }

  // --- MACROS E CALORIAS ---
  // Valores atuais
  int _currentKcal = 0;
  int _currentProtein = 0;
  int _currentCarbo = 0;
  int _currentFat = 0;

  // Metas diárias
  final int _goalKcal = 3200;
  final int _goalProtein = 160;
  final int _goalCarbo = 350;
  final int _goalFat = 80;

  // Getters para a tela ler os dados
  int get currentKcal => _currentKcal;
  int get goalKcal => _goalKcal;
  double get kcalProgress => (_currentKcal / _goalKcal).clamp(0.0, 1.0);

  int get currentProtein => _currentProtein;
  int get goalProtein => _goalProtein;
  double get proteinProgress => (_currentProtein / _goalProtein).clamp(0.0, 1.0);

  int get currentCarbo => _currentCarbo;
  int get goalCarbo => _goalCarbo;
  double get carboProgress => (_currentCarbo / _goalCarbo).clamp(0.0, 1.0);

  int get currentFat => _currentFat;
  int get goalFat => _goalFat;
  double get fatProgress => (_currentFat / _goalFat).clamp(0.0, 1.0);

  // A função que nossa futura IA vai chamar para injetar os dados calculados!
  void addMealMacros({required int kcal, required int protein, required int carbo, required int fat}) {
    _currentKcal += kcal;
    _currentProtein += protein;
    _currentCarbo += carbo;
    _currentFat += fat;
    notifyListeners();
  }
}
