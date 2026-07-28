import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/ledger_ring.dart';
import '../widgets/section_header.dart';
import '../widgets/transaction_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final txs = provider.transactions;

    return Scaffold(
      appBar: AppBar(
        title: Text(Formatters.monthLabel(DateTime.now())),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, size: 21),
            onPressed: () => _showBudgetSheet(context, provider),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: [
            // Balance summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TOTAL BALANCE',
                      style: TextStyle(
                          fontSize: 11.5,
                          letterSpacing: 1.1,
                          color: AppColors.paper.withOpacity(0.6),
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text(
                    Formatters.currency(provider.balance),
                    style: AppText.mono.copyWith(
                        fontSize: 32, color: AppColors.paper, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _MiniStat(
                        label: 'Income',
                        value: Formatters.currency(provider.monthIncome),
                        color: const Color(0xFF7FD6B6),
                      ),
                      const SizedBox(width: 24),
                      _MiniStat(
                        label: 'Spent',
                        value: Formatters.currency(provider.monthExpense),
                        color: const Color(0xFFE39C8B),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Budget ring — signature element
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                color: AppColors.paperElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                children: [
                  LedgerRing(
                    fraction: provider.budgetUsedFraction,
                    centerValue: Formatters.currency(
                        (provider.monthlyBudget - provider.monthExpense).clamp(0, double.infinity)),
                    centerLabel: 'LEFT TO SPEND',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'of ${Formatters.currency(provider.monthlyBudget)} budget',
                    style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),

            SectionHeader(title: 'Recent activity'),
            if (txs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text('Nothing logged yet — add your first transaction.',
                      style: TextStyle(color: AppColors.muted)),
                ),
              )
            else
              ...List.generate(txs.length, (i) {
                final showDivider = i != txs.length - 1;
                return Column(
                  children: [
                    TransactionTile(
                      tx: txs[i],
                      onDismissed: () => provider.deleteTransaction(txs[i].id),
                    ),
                    if (showDivider) const Divider(height: 1),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }

  void _showBudgetSheet(BuildContext context, ExpenseProvider provider) {
    final controller = TextEditingController(text: provider.monthlyBudget.toStringAsFixed(0));
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Monthly budget', style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: AppText.mono.copyWith(fontSize: 16),
              decoration: const InputDecoration(prefixText: '\u20B9 '),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final value = double.tryParse(controller.text);
                  if (value != null && value > 0) provider.setBudget(value);
                  Navigator.pop(ctx);
                },
                child: const Text('Save budget'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(fontSize: 11.5, color: AppColors.paper.withOpacity(0.65))),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: AppText.mono.copyWith(fontSize: 14.5, color: AppColors.paper)),
      ],
    );
  }
}
