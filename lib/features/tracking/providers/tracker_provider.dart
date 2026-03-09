import 'package:flutter/material.dart';

class TrackerProvider extends ChangeNotifier {
  // Quantidade inicial de água bebida hoje (em ml)
  int _waterIntake = 0;
  
  // A meta diária (3 Litros = 3000 ml)
  final int _waterGoal = 3000;

  // "Getters" para as telas poderem ler os dados
  int get waterIntake => _waterIntake;
  int get waterGoal => _waterGoal;
  
  // Calcula a percentagem para a barra de progresso (0.0 a 1.0)
  double get waterProgress {
    double progress = _waterIntake / _waterGoal;
    return progress > 1.0 ? 1.0 : progress; // Trava no 100% para a barra não quebrar
  }

  // Função que será chamada quando o botão "+ 250ml" for clicado
  void addWater(int amount) {
    _waterIntake += amount;
    
    // O segredo do Provider: avisa as telas que o valor mudou para elas se redesenharem!
    notifyListeners(); 
  }
}
