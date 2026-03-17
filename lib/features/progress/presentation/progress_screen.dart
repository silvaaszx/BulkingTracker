import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../tracking/providers/tracker_provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // ─── Registrar Peso ────────────────────────────────────────────────────────

  void _showLogWeightSheet(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final tracker = context.read<TrackerProvider>();

    // Pré-preenche com o peso atual para facilitar
    if (tracker.currentWeight > 0) {
      controller.text = tracker.currentWeight.toStringAsFixed(1);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.monitor_weight_outlined,
                      color: Colors.deepPurpleAccent, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Registrar Peso',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Seu progresso é salvo no histórico automaticamente.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: '0.0',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  suffixText: 'kg',
                  suffixStyle: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                        color: Colors.deepPurpleAccent, width: 1.5),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                    shadowColor: Colors.deepPurpleAccent.withOpacity(0.4),
                  ),
                  onPressed: () {
                    final weight =
                        double.tryParse(controller.text.replaceAll(',', '.'));
                    if (weight == null || weight <= 0) return;

                    context.read<TrackerProvider>().logWeight(weight);
                    Navigator.pop(ctx);

                    toastification.show(
                      context: context,
                      type: ToastificationType.success,
                      style: ToastificationStyle.flatColored,
                      title: Text(
                        '${weight.toStringAsFixed(1)} kg registrado!',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      description: const Text('Histórico atualizado.',
                          style: TextStyle(color: Colors.white70)),
                      backgroundColor: Colors.deepPurple.shade900,
                      primaryColor: Colors.deepPurpleAccent,
                      autoCloseDuration: const Duration(seconds: 3),
                      borderRadius: BorderRadius.circular(16),
                    );
                  },
                  icon: const Icon(Icons.save_alt_outlined, color: Colors.white),
                  label: const Text(
                    'Salvar Peso',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        );
      },
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurpleAccent;
    final tracker = context.watch<TrackerProvider>();

    final history = tracker.weightHistory;
    final currentWeight = tracker.currentWeight;
    final startingWeight = tracker.startingWeight;

    // Métricas de resumo
    final double totalGain = currentWeight - startingWeight;
    final String gainText = totalGain > 0
        ? '+ ${totalGain.toStringAsFixed(1)} kg'
        : '${totalGain.toStringAsFixed(1)} kg';
    final Color gainColor =
        totalGain > 0 ? Colors.greenAccent : Colors.white;

    final double weightDiff = (tracker.goalWeight - currentWeight).abs();
    final String missingText =
        currentWeight >= tracker.goalWeight && tracker.goalWeight > 0
            ? 'Meta Alcançada! 🎉'
            : '${weightDiff.toStringAsFixed(1)} kg';

    // Prepara pontos do gráfico a partir do histórico real
    final bool hasHistory = history.length >= 2;
    final List<FlSpot> spots = hasHistory
        ? history
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.weight))
            .toList()
        : [
            FlSpot(0, startingWeight > 0 ? startingWeight : 0),
            FlSpot(1, currentWeight > 0 ? currentWeight : 0),
          ];

    final double minY =
        (spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) - 3)
            .clamp(0.0, double.infinity);
    final double maxY =
        spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) + 3;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F12),
      appBar: AppBar(
        title: const Text('Evolução de Peso',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sua Trajetória',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                hasHistory
                    ? '${history.length} registros de peso salvos'
                    : 'Registre seu peso para começar o histórico',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 32),

              // ─── Gráfico ─────────────────────────────────────────────────
              Container(
                height: 320,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                      color: primaryColor.withOpacity(0.06),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                      color: Colors.white.withOpacity(0.02), width: 1),
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOutCubic,
                  builder: (context, animVal, _) {
                    return LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.white.withOpacity(0.05),
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          ),
                        ),
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: hasHistory,
                              reservedSize: 32,
                              interval: history.length > 10
                                  ? (history.length / 5).ceilToDouble()
                                  : 1,
                              getTitlesWidget: (val, meta) {
                                final idx = val.toInt();
                                if (idx < 0 || idx >= history.length) {
                                  return const SizedBox.shrink();
                                }
                                final d = history[idx].date;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    '${d.day}/${d.month}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 11),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 44,
                              getTitlesWidget: (val, meta) => Text(
                                '${val.toInt()}kg',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: (spots.length - 1).toDouble() * animVal,
                        minY: minY,
                        maxY: maxY,
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            curveSmoothness: 0.3,
                            color: primaryColor,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) =>
                                  FlDotCirclePainter(
                                radius: history.length > 15 ? 2 : 4,
                                color: Colors.white,
                                strokeWidth: 2,
                                strokeColor: primaryColor,
                              ),
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor.withOpacity(0.35),
                                  primaryColor.withOpacity(0.0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ─── Cards de resumo ──────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                      child: _buildSummaryCard(
                          'Ganho Total', gainText, gainColor)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildSummaryCard(
                          'Faltam', missingText, Colors.deepPurpleAccent)),
                ],
              ),

              const SizedBox(height: 24),

              // ─── Botão registrar peso ─────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                    shadowColor: Colors.deepPurpleAccent.withOpacity(0.4),
                  ),
                  onPressed: () => _showLogWeightSheet(context),
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                  label: const Text(
                    'Registrar Peso de Hoje',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ).animate().scale(
                  delay: 400.ms,
                  duration: 600.ms,
                  curve: Curves.elasticOut),

              const SizedBox(height: 32),
            ].animate(interval: 100.ms).fade(duration: 400.ms, curve: Curves.easeOutCubic).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color glowColor) {
    return Container(
      padding: const EdgeInsets.all(20),
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
            color: glowColor.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
        border:
            Border.all(color: Colors.white.withOpacity(0.02), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              color: glowColor,
              shadows: [
                Shadow(color: glowColor.withOpacity(0.5), blurRadius: 10)
              ],
            ),
          ),
        ],
      ),
    ).animate().scale(delay: 400.ms, duration: 600.ms, curve: Curves.elasticOut);
  }
}
