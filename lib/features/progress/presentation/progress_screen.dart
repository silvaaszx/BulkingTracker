import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evolução de Peso', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sua Trajetória',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Acompanhe seus ganhos ao longo das semanas',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
            const SizedBox(height: 32),
            
            // O Card que vai segurar o nosso gráfico
            Container(
              height: 300,
              padding: const EdgeInsets.only(right: 24, left: 16, top: 24, bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[800],
                        strokeWidth: 1,
                        dashArray: [5, 5], // Deixa a linha de fundo pontilhada e elegante
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(color: Colors.grey, fontSize: 12);
                          // Valores do Eixo X (Semanas)
                          switch (value.toInt()) {
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
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}kg',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false), // Tira aquela borda quadrada feia
                  minX: 1,
                  maxX: 4,
                  minY: 50, // Peso mínimo do gráfico
                  maxY: 65, // Peso máximo para dar espaço
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(1, 52.0), // Semana 1: 52kg
                        FlSpot(2, 53.5), // Semana 2: 53.5kg
                        FlSpot(3, 54.2), // Semana 3: 54.2kg
                        FlSpot(4, 55.8), // Semana 4: 55.8kg
                      ],
                      isCurved: true, // Deixa a linha suave, sem quinas
                      color: primaryColor,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true), // Mostra a bolinha em cada marcação
                      belowBarData: BarAreaData(
                        show: true,
                        // Faz um degradê bonitão embaixo da linha
                        color: primaryColor.withOpacity(0.2), 
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Resumo extra embaixo do gráfico
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(context, 'Ganho Total', '+ 3.8kg', Colors.green),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(context, 'Faltam', '14.2kg', primaryColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, Color valueColor) {
    return Container(
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
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: valueColor)),
        ],
      ),
    );
  }
}
