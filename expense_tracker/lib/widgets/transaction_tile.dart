import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class TransactionTile extends StatelessWidget {
  final MoneyTransaction tx;
  final VoidCallback? onDismissed;

  const TransactionTile({super.key, required this.tx, this.onDismissed});

  @override
  Widget build(BuildContext context) {
    final cat = tx.category;
    final isExpense = tx.type.name == 'expense';

    return Dismissible(
      key: ValueKey(tx.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.expenseSoft,
        child: const Icon(Icons.delete_outline, color: AppColors.expense),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cat.color.withOpacity(0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(cat.icon, size: 19, color: cat.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.title,
                      style: const TextStyle(
                          fontSize: 14.5, fontWeight: FontWeight.w500, color: AppColors.ink)),
                  const SizedBox(height: 2),
                  Text(cat.label,
                      style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                ],
              ),
            ),
            Text(
              Formatters.currencySigned(tx.signedAmount),
              style: AppText.mono.copyWith(
                fontSize: 14,
                color: isExpense ? AppColors.expense : AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
