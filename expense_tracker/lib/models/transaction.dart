import 'category.dart';

class MoneyTransaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String categoryId;
  final TxType type;
  final String? note;

  MoneyTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.type,
    this.note,
  });

  ExpenseCategory get category => ExpenseCategory.byId(categoryId);

  /// Signed amount: negative for expenses, positive for income.
  double get signedAmount => type == TxType.expense ? -amount.abs() : amount.abs();
}
