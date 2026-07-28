import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/section_header.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final byCategory = provider.expenseByCategory;
    final entries = byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxValue = entries.isEmpty
        ? 1.0
        : entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final total = entries.fold(0.0, (sum, e) => sum + e.value);

    return Scaffold(
      appBar: AppBar(title: const Text('Spending')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.paperElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SPENT THIS MONTH',
                      style: TextStyle(
                          fontSize: 11.5, letterSpacing: 1, color: AppColors.muted, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(Formatters.currency(total),
                      style: AppText.mono.copyWith(fontSize: 26, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  if (entries.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text('No expenses logged this month yet.',
                            style: TextStyle(color: AppColors.muted)),
                      ),
                    )
                  else
                    SizedBox(
                      height: 180,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxValue * 1.25,
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final idx = value.toInt();
                                  if (idx < 0 || idx >= entries.length) return const SizedBox();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Icon(entries[idx].key.icon, size: 15, color: entries[idx].key.color),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: List.generate(entries.length, (i) {
                            final e = entries[i];
                            return BarChartGroupData(x: i, barRods: [
                              BarChartRodData(
                                toY: e.value,
                                color: e.key.color,
                                width: 22,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ]);
                          }),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const SectionHeader(title: 'By category'),
            if (entries.isEmpty)
              const SizedBox()
            else
              ...entries.map((e) => _CategoryRow(
                    category: e.key,
                    amount: e.value,
                    fraction: total == 0 ? 0 : e.value / total,
                  )),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final ExpenseCategory category;
  final double amount;
  final double fraction;

  const _CategoryRow({required this.category, required this.amount, required this.fraction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(category.icon, size: 16, color: category.color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(category.label,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ),
              Text(Formatters.currency(amount), style: AppText.mono.copyWith(fontSize: 13.5)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor: AppColors.line,
              color: category.color,
            ),
          ),
        ],
      ),
    );
  }
}
