import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../tracking/providers/tracker_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurpleAccent;
    final tracker = context.watch<TrackerProvider>();
    
    final currentWeight = tracker.currentWeight;
    final startingWeight = tracker.startingWeight;
    
    final double weightDiff = (tracker.goalWeight - currentWeight).abs();
    final String missingText = currentWeight >= tracker.goalWeight && tracker.goalWeight > 0 
        ? 'Meta Alcançada!' 
        : '${weightDiff.toStringAsFixed(1)}kg';
        
    final double totalGain = currentWeight - startingWeight;
    final String gainText = totalGain > 0 ? '+ ${totalGain.toStringAsFixed(1)}kg' : '${totalGain.toStringAsFixed(1)}kg';
    final Color gainColor = totalGain > 0 ? Colors.greenAccent : Colors.white;

    final double minW = startingWeight < currentWeight ? startingWeight : currentWeight;
    final double maxW = startingWeight > currentWeight ? startingWeight : currentWeight;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F12),
      appBar: AppBar(
        title: const Text('Evolução de Peso', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
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
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Acompanhe seus ganhos ao longo das semanas',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 32),
              
              // O Card do Gráfico
              Container(
                height: 320,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                      color: primaryColor.withOpacity(0.04),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: Colors.white.withOpacity(0.02), width: 1),
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white.withOpacity(0.05),
                              strokeWidth: 1,
                              dashArray: [5, 5],
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (val, meta) {
                                const style = TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold);
                                switch (val.toInt()) {
                                  case 1: return const Text('Sem 1', style: style);
                                  case 2: return const Text('Sem 2', style: style);
                                  case 3: return const Text('Sem 3', style: style);
                                  case 4: return const Text('Sem 4', style: style);
                                }
                                return const Text('', style: style);
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (val, meta) {
                                return Text(
                                  '${val.toInt()}kg',
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 1,
                        maxX: 1 + (3 * value), // Anima a linha sendo revelada
                        minY: minW > 5 ? minW - 5 : 0,
                        maxY: maxW == 0 ? 10 : maxW + 5,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(1, startingWeight),
                              FlSpot(2, startingWeight + (totalGain * 0.33)),
                              FlSpot(3, startingWeight + (totalGain * 0.66)),
                              FlSpot(4, currentWeight),
                            ],
                            isCurved: true,
                            color: primaryColor,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: Colors.white,
                                  strokeWidth: 2,
                                  strokeColor: primaryColor,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor.withOpacity(0.4),
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
              
              // Resumo Inferior
              Row(
                children: [
                   Expanded(child: _buildSummaryCard('Ganho Total', gainText, gainColor)),
                   const SizedBox(width: 16),
                   Expanded(child: _buildSummaryCard('Faltam', missingText, Colors.deepPurpleAccent)),
                ],
              )
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
        border: Border.all(color: Colors.white.withOpacity(0.02), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            value, 
            style: TextStyle(
              fontWeight: FontWeight.w900, 
              fontSize: 24, 
              color: glowColor,
              shadows: [Shadow(color: glowColor.withOpacity(0.5), blurRadius: 10)],
            ),
          ),
        ],
      ),
    ).animate().scale(delay: 400.ms, duration: 600.ms, curve: Curves.elasticOut);
  }
}
