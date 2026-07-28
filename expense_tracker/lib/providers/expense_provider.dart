import 'package:flutter/foundation.dart';
import '../models/category.dart';
import '../models/transaction.dart';


class ExpenseProvider extends ChangeNotifier {
  final List<MoneyTransaction> _transactions = [];

  /// Monthly budget used to drive the ledger ring on the home screen.
  double monthlyBudget = 2000;

  List<MoneyTransaction> get transactions =>
      List.unmodifiable(_transactions..sort((a, b) => b.date.compareTo(a.date)));

  List<MoneyTransaction> get thisMonth {
    final now = DateTime.now();
    return _transactions
        .where((t) => t.date.year == now.year && t.date.month == now.month)
        .toList();
  }

  double get balance =>
      _transactions.fold(0.0, (sum, t) => sum + t.signedAmount);

  double get monthIncome => thisMonth
      .where((t) => t.type == TxType.income)
      .fold(0.0, (sum, t) => sum + t.amount.abs());

  double get monthExpense => thisMonth
      .where((t) => t.type == TxType.expense)
      .fold(0.0, (sum, t) => sum + t.amount.abs());

  double get budgetUsedFraction =>
      monthlyBudget <= 0 ? 0 : (monthExpense / monthlyBudget).clamp(0.0, 1.0);

  /// Expense total grouped by category, for the current month — used by
  /// the stats screen bar chart.
  Map<ExpenseCategory, double> get expenseByCategory {
    final Map<String, double> totals = {};
    for (final t in thisMonth.where((t) => t.type == TxType.expense)) {
      totals.update(t.categoryId, (v) => v + t.amount.abs(),
          ifAbsent: () => t.amount.abs());
    }
    final result = <ExpenseCategory, double>{};
    for (final entry in totals.entries) {
      result[ExpenseCategory.byId(entry.key)] = entry.value;
    }
    return result;
  }

  void addTransaction(MoneyTransaction tx) {
    _transactions.add(tx);
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void setBudget(double value) {
    monthlyBudget = value;
    notifyListeners();
  }
}
