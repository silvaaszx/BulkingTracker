import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackerProvider extends ChangeNotifier {
  // --- DADOS DO UTILIZADOR (NOVOS) ---
  String _userName = 'Atleta';
  double _currentWeight = 0.0;
  double _goalWeight = 0.0;

  String get userName => _userName;
  double get currentWeight => _currentWeight;
  double get goalWeight => _goalWeight;

  // --- ÁGUA ---
  int _waterIntake = 0;
  final int _waterGoal = 3000;
  
  // --- MACROS E CALORIAS ---
  int _currentKcal = 0;
  int _currentProtein = 0;
  int _currentCarbo = 0;
  int _currentFat = 0;

  final int _goalKcal = 3200;
  final int _goalProtein = 160;
  final int _goalCarbo = 350;
  final int _goalFat = 80;

  // Construtor: Assim que o app abre, ele puxa os dados salvos!
  TrackerProvider() {
    _loadData();
  }

  // Getters da Água
  int get waterIntake => _waterIntake;
  int get waterGoal => _waterGoal;
  double get waterProgress => (_waterIntake / _waterGoal).clamp(0.0, 1.0);

  // Getters dos Macros
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

  // Funções de Ação
  void addWater(int amount) {
    _waterIntake += amount;
    _saveData(); // Salva sempre que mudar
    notifyListeners();
  }

  void addMealMacros({required int kcal, required int protein, required int carbo, required int fat}) {
    _currentKcal += kcal;
    _currentProtein += protein;
    _currentCarbo += carbo;
    _currentFat += fat;
    _saveData(); // Salva sempre que comer
    notifyListeners();
  }

  // ==========================================
  // LÓGICA DE MEMÓRIA (SHARED PREFERENCES)
  // ==========================================

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Carregar dados do perfil
    _userName = prefs.getString('userName') ?? 'Atleta';
    _currentWeight = prefs.getDouble('currentWeight') ?? 0.0;
    _goalWeight = prefs.getDouble('goalWeight') ?? 0.0;
    
    _waterIntake = prefs.getInt('waterIntake') ?? 0;
    _currentKcal = prefs.getInt('currentKcal') ?? 0;
    _currentProtein = prefs.getInt('currentProtein') ?? 0;
    _currentCarbo = prefs.getInt('currentCarbo') ?? 0;
    _currentFat = prefs.getInt('currentFat') ?? 0;
    notifyListeners(); // Atualiza a tela depois de carregar da memória
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    // Salvar perfil
    await prefs.setString('userName', _userName);
    await prefs.setDouble('currentWeight', _currentWeight);
    await prefs.setDouble('goalWeight', _goalWeight);
    await prefs.setInt('waterIntake', _waterIntake);
    await prefs.setInt('currentKcal', _currentKcal);
    await prefs.setInt('currentProtein', _currentProtein);
    await prefs.setInt('currentCarbo', _currentCarbo);
    await prefs.setInt('currentFat', _currentFat);
  }
}
