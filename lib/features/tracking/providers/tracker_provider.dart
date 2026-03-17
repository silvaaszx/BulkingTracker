import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Model: Entrada de peso no histórico
// ---------------------------------------------------------------------------
class WeightEntry {
  final DateTime date;
  final double weight;

  const WeightEntry({required this.date, required this.weight});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'weight': weight,
      };

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
        date: DateTime.parse(json['date'] as String),
        weight: (json['weight'] as num).toDouble(),
      );
}

// ---------------------------------------------------------------------------
// TrackerProvider
// ---------------------------------------------------------------------------
class TrackerProvider extends ChangeNotifier {
  // --- DADOS DO PERFIL ---
  String _userName = 'Atleta';
  double _currentWeight = 0.0;
  double _goalWeight = 0.0;
  double _startingWeight = 0.0;

  String get userName => _userName;
  double get currentWeight => _currentWeight;
  double get goalWeight => _goalWeight;
  double get startingWeight => _startingWeight;

  // --- ÁGUA ---
  int _waterIntake = 0;
  final int _waterGoal = 3000;

  // --- MACROS E CALORIAS (diários) ---
  int _currentKcal = 0;
  int _currentProtein = 0;
  int _currentCarbo = 0;
  int _currentFat = 0;

  int _goalKcal = 0;
  int _goalProtein = 0;
  int _goalCarbo = 0;
  int _goalFat = 0;

  // --- HISTÓRICO DE PESO ---
  List<WeightEntry> _weightHistory = [];
  List<WeightEntry> get weightHistory => List.unmodifiable(_weightHistory);

  // --- LÓGICA DE TOAST ---
  bool _waterToastShown = false;

  bool checkWaterAchievement() {
    if (_waterIntake >= _waterGoal && !_waterToastShown) {
      _waterToastShown = true;
      return true;
    }
    return false;
  }

  // Future público para que o main.dart possa aguardar a inicialização completa
  late final Future<void> initFuture;

  TrackerProvider() {
    initFuture = _loadData();
  }

  // ---------------------------------------------------------------------------
  // Getters de Água
  // ---------------------------------------------------------------------------
  int get waterIntake => _waterIntake;
  int get waterGoal => _waterGoal;
  double get waterProgress =>
      _waterGoal > 0 ? (_waterIntake / _waterGoal).clamp(0.0, 1.0) : 0.0;

  // ---------------------------------------------------------------------------
  // Getters de Macros (com proteção divisão/zero)
  // ---------------------------------------------------------------------------
  int get currentKcal => _currentKcal;
  int get goalKcal => _goalKcal;
  double get kcalProgress =>
      _goalKcal > 0 ? (_currentKcal / _goalKcal).clamp(0.0, 1.0) : 0.0;

  int get currentProtein => _currentProtein;
  int get goalProtein => _goalProtein;
  double get proteinProgress =>
      _goalProtein > 0 ? (_currentProtein / _goalProtein).clamp(0.0, 1.0) : 0.0;

  int get currentCarbo => _currentCarbo;
  int get goalCarbo => _goalCarbo;
  double get carboProgress =>
      _goalCarbo > 0 ? (_currentCarbo / _goalCarbo).clamp(0.0, 1.0) : 0.0;

  int get currentFat => _currentFat;
  int get goalFat => _goalFat;
  double get fatProgress =>
      _goalFat > 0 ? (_currentFat / _goalFat).clamp(0.0, 1.0) : 0.0;

  // ---------------------------------------------------------------------------
  // Lógica de Bulking — Cálculo automático de macros pelo peso
  // ---------------------------------------------------------------------------
  void calculateAndSaveMacros(double currentWeight) {
    if (currentWeight <= 0) return;
    _currentWeight = currentWeight;
    _goalProtein = (currentWeight * 2.2).toInt();
    _goalFat = (currentWeight * 1.0).toInt();
    _goalKcal = (currentWeight * 40).toInt();
    _goalCarbo =
        ((_goalKcal - (_goalProtein * 4) - (_goalFat * 9)) / 4).toInt();
    _saveData();
    notifyListeners();
  }

  void setProfile(String name, double goalWeight) {
    _userName = name;
    _goalWeight = goalWeight;
    _saveData();
    notifyListeners();
  }

  void setStartingWeight(double weight) {
    _startingWeight = weight;
    _saveData();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Ações Diárias
  // ---------------------------------------------------------------------------
  void addWater(int amount) {
    _waterIntake += amount;
    _saveData();
    notifyListeners();
  }

  void addMealMacros({
    required int kcal,
    required int protein,
    required int carbo,
    required int fat,
  }) {
    _currentKcal += kcal;
    _currentProtein += protein;
    _currentCarbo += carbo;
    _currentFat += fat;
    _saveData();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Histórico de Peso
  // ---------------------------------------------------------------------------

  /// Registra o peso atual no histórico (um registro por dia — sobrescreve
  /// se já existir entrada para hoje) e recalcula as metas de macros.
  void logWeight(double weight) {
    if (weight <= 0) return;
    final today = _dateOnly(DateTime.now());

    // Remove entrada de hoje se já existir (para sobrescrever)
    _weightHistory.removeWhere(
        (e) => _dateOnly(e.date).isAtSameMomentAs(today));

    _weightHistory.add(WeightEntry(date: today, weight: weight));

    // Mantém só os últimos 90 dias para não inflar o storage
    _weightHistory.sort((a, b) => a.date.compareTo(b.date));
    if (_weightHistory.length > 90) {
      _weightHistory = _weightHistory.sublist(_weightHistory.length - 90);
    }

    // Atualiza peso atual e recalcula macros
    calculateAndSaveMacros(weight);
    _saveData();
    notifyListeners();
  }

  // Helper: retorna DateTime apenas com ano/mês/dia (sem hora)
  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  // ---------------------------------------------------------------------------
  // MEMÓRIA — SharedPreferences
  // ---------------------------------------------------------------------------

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Perfil
    _userName = prefs.getString('userName') ?? 'Atleta';
    _currentWeight = prefs.getDouble('currentWeight') ?? 0.0;
    _goalWeight = prefs.getDouble('goalWeight') ?? 0.0;
    _startingWeight = prefs.getDouble('startingWeight') ?? _currentWeight;

    // Metas
    _goalKcal = prefs.getInt('goalKcal') ?? 0;
    _goalProtein = prefs.getInt('goalProtein') ?? 0;
    _goalCarbo = prefs.getInt('goalCarbo') ?? 0;
    _goalFat = prefs.getInt('goalFat') ?? 0;

    // Valores diários
    _waterIntake = prefs.getInt('waterIntake') ?? 0;
    _currentKcal = prefs.getInt('currentKcal') ?? 0;
    _currentProtein = prefs.getInt('currentProtein') ?? 0;
    _currentCarbo = prefs.getInt('currentCarbo') ?? 0;
    _currentFat = prefs.getInt('currentFat') ?? 0;

    // Histórico de peso
    final historyJson = prefs.getString('weightHistory');
    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson) as List<dynamic>;
      _weightHistory = decoded
          .map((e) => WeightEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // ─── RESET DIÁRIO ─────────────────────────────────────────────────────
    final today = _dateOnly(DateTime.now()).toIso8601String();
    final lastOpened = prefs.getString('lastOpenedDate') ?? '';

    if (lastOpened != today) {
      // Novo dia: zera apenas os contadores diários
      _waterIntake = 0;
      _currentKcal = 0;
      _currentProtein = 0;
      _currentCarbo = 0;
      _currentFat = 0;
      _waterToastShown = false;
      await prefs.setString('lastOpenedDate', today);
    }
    // ──────────────────────────────────────────────────────────────────────

    // Se tiver peso, garante que as metas estão calculadas
    if (_currentWeight > 0 && _goalKcal == 0) {
      calculateAndSaveMacros(_currentWeight);
    } else {
      notifyListeners();
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Perfil
    await prefs.setString('userName', _userName);
    await prefs.setDouble('currentWeight', _currentWeight);
    await prefs.setDouble('goalWeight', _goalWeight);
    await prefs.setDouble('startingWeight', _startingWeight);

    // Metas
    await prefs.setInt('goalKcal', _goalKcal);
    await prefs.setInt('goalProtein', _goalProtein);
    await prefs.setInt('goalCarbo', _goalCarbo);
    await prefs.setInt('goalFat', _goalFat);

    // Valores diários
    await prefs.setInt('waterIntake', _waterIntake);
    await prefs.setInt('currentKcal', _currentKcal);
    await prefs.setInt('currentProtein', _currentProtein);
    await prefs.setInt('currentCarbo', _currentCarbo);
    await prefs.setInt('currentFat', _currentFat);

    // Histórico de peso
    final historyJson =
        jsonEncode(_weightHistory.map((e) => e.toJson()).toList());
    await prefs.setString('weightHistory', historyJson);
  }
}
