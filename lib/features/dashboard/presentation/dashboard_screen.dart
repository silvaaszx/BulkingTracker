import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:toastification/toastification.dart';
import '../../tracking/providers/tracker_provider.dart';
import '../../tracking/services/gemini_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isWaterHovered = false;

  void _checkAchievements(TrackerProvider provider) {
    if (provider.checkWaterAchievement()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flatColored,
          title: const Text('🎉 Conquista: Hidratado!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          icon: const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
          primaryColor: Colors.deepPurpleAccent,
          backgroundColor: Colors.deepPurple.shade900,
          foregroundColor: Colors.white,
          autoCloseDuration: const Duration(seconds: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
            )
          ],
        );
      });
    }
  }

  Widget _buildPremiumCard(BuildContext context, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161618),
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [Colors.grey.shade900, const Color(0xFF1A1A24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withOpacity(0.04),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.02), width: 1),
      ),
      padding: const EdgeInsets.all(24.0),
      child: child,
    );
  }

  Widget _buildTestTubeWater(double progress) {
    return Container(
      width: 48,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: progress),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return FractionallySizedBox(
                  heightFactor: value,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.lightBlueAccent, Colors.blueAccent.shade700],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterButton(TrackerProvider provider) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isWaterHovered = true),
      onTapUp: (_) {
        setState(() => _isWaterHovered = false);
        provider.addWater(250);
      },
      onTapCancel: () => setState(() => _isWaterHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_isWaterHovered ? 0.92 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Colors.lightBlue, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(_isWaterHovered ? 0.8 : 0.5),
              blurRadius: _isWaterHovered ? 20 : 15,
              spreadRadius: _isWaterHovered ? 4 : 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: const Icon(Icons.water_drop, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildCircularKcal(int current, int goal, double progress) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: progress),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: value,
                backgroundColor: Colors.black.withOpacity(0.4),
                color: Colors.orangeAccent,
                strokeWidth: 10,
                strokeAlign: CircularProgressIndicator.strokeAlignInside,
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              children: [
                const Text('Calorias', style: TextStyle(color: Colors.white70, fontSize: 12)),
                Text(
                  '$current',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.orangeAccent),
                ),
                Text('/ $goal', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMacroProgress(String label, String value, String subtitle, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white)),
            Text(value, style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: progress),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
          builder: (context, animValue, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: constraints.maxWidth * animValue,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          )
                        ],
                        gradient: LinearGradient(
                          colors: [color.withOpacity(0.7), color],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                );
              }
            );
          },
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
      ],
    );
  }

  void _showAddMealBottomSheet(BuildContext context) {
    final TextEditingController mealController = TextEditingController();
    bool isAnalyzing = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
                left: 20, right: 20, top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.deepPurpleAccent, size: 24),
                      SizedBox(width: 8),
                      Text('IA Nutricional', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Descreva sua refeição, nós calculamos os macros.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: mealController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    enabled: !isAnalyzing,
                    decoration: InputDecoration(
                      hintText: 'Ex: Comi 150g de arroz branco, 100g de frango grelhado...',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                        shadowColor: Colors.deepPurpleAccent.withOpacity(0.4),
                      ),
                      onPressed: isAnalyzing ? null : () async {
                        final text = mealController.text.trim();
                        if (text.isEmpty) return;

                        setModalState(() { isAnalyzing = true; });
                        final service = GeminiService();
                        Map<String, int>? result;
                        String? errorMsg;
                        try {
                          result = await service.analyzeMeal(text);
                        } catch (e) {
                          if (e.toString().contains('network_error')) {
                            errorMsg = 'Falha na conexão. Verifique sua internet.';
                          } else {
                            errorMsg = 'Ops! A IA não conseguiu entender. Tente detalhar mais.';
                          }
                        }
                        
                        // Guarda mounted antes do gap assíncrono para evitar crash
                        if (!context.mounted) return;
                        setModalState(() { isAnalyzing = false; });

                        if (errorMsg != null) {
                           toastification.show(
                             context: context,
                             type: ToastificationType.error,
                             style: ToastificationStyle.flatColored,
                             title: Text(errorMsg, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                             description: const Text('Por favor, tente novamente.', style: TextStyle(color: Colors.white70)),
                             backgroundColor: Colors.red.shade900,
                             primaryColor: Colors.redAccent,
                             autoCloseDuration: const Duration(seconds: 4),
                             borderRadius: BorderRadius.circular(16),
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.redAccent.withOpacity(0.4),
                                 blurRadius: 15,
                                 spreadRadius: 2,
                               )
                             ]
                           );
                           return;
                        }

                        if (result != null) {
                          bottomSheetContext.read<TrackerProvider>().addMealMacros(
                            kcal: result['kcal']!,
                            protein: result['protein']!,
                            carbo: result['carbo']!,
                            fat: result['fat']!,
                          );
                          Navigator.pop(bottomSheetContext);
                          toastification.show(
                            context: context,
                            type: ToastificationType.success,
                            style: ToastificationStyle.flatColored,
                            title: Text('Refeição Registrada: ${result['kcal']}kcal', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            description: Text('${result['protein']}g P, ${result['carbo']}g C, ${result['fat']}g G', style: const TextStyle(color: Colors.white70)),
                            backgroundColor: Colors.deepPurple.shade900,
                            primaryColor: Colors.deepPurpleAccent,
                            autoCloseDuration: const Duration(seconds: 3),
                            borderRadius: BorderRadius.circular(16),
                          );
                        }
                      },
                      icon: isAnalyzing
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.analytics_outlined, color: Colors.white),
                      label: Text(
                        isAnalyzing ? 'Analisando...' : 'Analisar com IA',
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

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<TrackerProvider>();
    _checkAchievements(tracker);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F12),
      appBar: AppBar(
        title: const Text('BulkingTracker', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120, left: 24, right: 24, top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Fala, ${tracker.userName}!',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Pronto para esmagar as metas de hoje?',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 28),
              
              // Calorias Card
              _buildPremiumCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 24),
                        SizedBox(width: 8),
                        Text('Calorias Diárias', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCircularKcal(tracker.currentKcal, tracker.goalKcal, tracker.kcalProgress),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // NOVO WIDGET: Meta de Peso
              _buildPremiumCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.monitor_weight_outlined, color: Colors.deepPurpleAccent, size: 24),
                        SizedBox(width: 8),
                        Text('Progresso do Bulking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Builder(
                      builder: (context) {
                        final double weightDiff = (tracker.goalWeight - tracker.currentWeight).abs();
                        final bool reached = tracker.currentWeight >= tracker.goalWeight && tracker.goalWeight > 0;
                        final String titleText = reached ? '🎉 Meta Alcançada!' : 'Faltam ${weightDiff.toStringAsFixed(1)} kg';
                        
                        final double totalNeeded = (tracker.goalWeight - tracker.startingWeight).abs();
                        final double currentGained = (tracker.currentWeight - tracker.startingWeight).abs();
                        double progress = (totalNeeded == 0) ? 1.0 : (currentGained / totalNeeded).clamp(0.0, 1.0);
                        if (reached) progress = 1.0;
                        if (progress < 0) progress = 0.0;

                        return Column(
                          children: [
                            Text(
                              titleText,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.purpleAccent,
                                shadows: [Shadow(color: Colors.deepPurpleAccent, blurRadius: 15)],
                              ),
                            ),
                            const SizedBox(height: 20),
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.0, end: progress),
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Container(
                                      height: 6,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          width: constraints.maxWidth * value,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.deepPurpleAccent.withOpacity(0.6),
                                                blurRadius: 12,
                                                spreadRadius: 2,
                                              )
                                            ],
                                            gradient: const LinearGradient(
                                              colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                );
                              },
                            ),
                          ],
                        );
                      }
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Macros Grid
              _buildPremiumCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.pie_chart_rounded, color: Colors.blueAccent, size: 24),
                        SizedBox(width: 8),
                        Text('Distribuição de Macros', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildMacroProgress(
                      'Proteína', 
                      '${tracker.currentProtein}g / ${tracker.goalProtein}g', 
                      'Faltam ${tracker.goalProtein - tracker.currentProtein}g', 
                      tracker.proteinProgress, 
                      Colors.redAccent
                    ),
                    const SizedBox(height: 16),
                    _buildMacroProgress(
                      'Carboidratos', 
                      '${tracker.currentCarbo}g / ${tracker.goalCarbo}g', 
                      'Faltam ${tracker.goalCarbo - tracker.currentCarbo}g', 
                      tracker.carboProgress, 
                      Colors.blueAccent
                    ),
                    const SizedBox(height: 16),
                    _buildMacroProgress(
                      'Gorduras', 
                      '${tracker.currentFat}g / ${tracker.goalFat}g', 
                      'Faltam ${tracker.goalFat - tracker.currentFat}g', 
                      tracker.fatProgress, 
                      Colors.amberAccent
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Water Card
              _buildPremiumCard(
                context,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.water_drop_outlined, color: Colors.blueAccent, size: 24),
                              SizedBox(width: 8),
                              Text('Hidratação', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${tracker.waterIntake} ml', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
                                  Text('Meta: ${tracker.waterGoal} ml', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                                ],
                              ),
                              _buildWaterButton(tracker),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildTestTubeWater(tracker.waterProgress),
                  ],
                ),
              ),
            ].animate(interval: 80.ms).fade(duration: 600.ms, curve: Curves.easeOutCubic).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMealBottomSheet(context),
        backgroundColor: Colors.deepPurpleAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nova Refeição', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ).animate().scale(delay: 500.ms, duration: 400.ms, curve: Curves.easeOutBack),
    );
  }
}