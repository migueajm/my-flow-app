import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/report_models.dart';
import '../utils/formatters.dart';
import 'empty_state.dart';

class ExpensePieChart extends StatelessWidget {
  const ExpensePieChart({super.key, required this.data});

  final List<CategoryTotal> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const EmptyState(
        icon: Icons.pie_chart_outline,
        title: 'Sin gastos',
        message: 'Registra gastos para ver la distribucion por categoria.',
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 46,
              sectionsSpace: 2,
              sections: data
                  .map(
                    (item) => PieChartSectionData(
                      value: item.total,
                      title: currencyFormat.format(item.total),
                      color: Color(item.color),
                      radius: 74,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Wrap(
          spacing: 18,
          runSpacing: 8,
          children: data
              .map(
                (item) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 10, height: 10, color: Color(item.color)),
                    const SizedBox(width: 6, height: 50),
                    Text(item.categoryName),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class PeriodBarChart extends StatelessWidget {
  const PeriodBarChart({super.key, required this.data});

  final List<PeriodTotal> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const EmptyState(
        icon: Icons.bar_chart,
        title: 'Sin datos',
        message: 'Este periodo todavia no tiene movimientos.',
      );
    }

    final maxY = data.map((e) => e.total).reduce((a, b) => a > b ? a : b) * 1.25;
    return SizedBox(
      height: 240,
      child: BarChart(
        BarChartData(
          maxY: maxY <= 0 ? 10 : maxY,
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(data[index].label, style: const TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < data.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: data[i].total,
                    color: Theme.of(context).colorScheme.primary,
                    width: 14,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class MonthlyLineChart extends StatelessWidget {
  const MonthlyLineChart({super.key, required this.data});

  final List<MonthlyComparison> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const EmptyState(
        icon: Icons.show_chart,
        title: 'Sin historico',
        message: 'Captura ingresos en varios meses para comparar.',
      );
    }

    final values = data.expand((e) => [e.expenses, e.savings]).toList();
    final maxY = values.reduce((a, b) => a > b ? a : b) * 1.25;
    return SizedBox(
      height: 260,
      child: LineChart(
        LineChartData(
          maxY: maxY <= 0 ? 10 : maxY,
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(data[index].label, style: const TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < data.length; i++) FlSpot(i.toDouble(), data[i].expenses),
              ],
              isCurved: true,
              color: Theme.of(context).colorScheme.error,
              barWidth: 3,
            ),
            LineChartBarData(
              spots: [
                for (var i = 0; i < data.length; i++) FlSpot(i.toDouble(), data[i].savings),
              ],
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
