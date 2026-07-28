import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum TxType { expense, income }

class ExpenseCategory {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const ExpenseCategory({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });

  static const food = ExpenseCategory(
    id: 'food',
    label: 'Food',
    icon: Icons.local_cafe_outlined,
    color: AppColors.catFood,
  );
  static const transport = ExpenseCategory(
    id: 'transport',
    label: 'Transport',
    icon: Icons.directions_bus_filled_outlined,
    color: AppColors.catTransport,
  );
  static const shopping = ExpenseCategory(
    id: 'shopping',
    label: 'Shopping',
    icon: Icons.shopping_bag_outlined,
    color: AppColors.catShopping,
  );
  static const bills = ExpenseCategory(
    id: 'bills',
    label: 'Bills',
    icon: Icons.receipt_long_outlined,
    color: AppColors.catBills,
  );
  static const fun = ExpenseCategory(
    id: 'fun',
    label: 'Fun',
    icon: Icons.local_movies_outlined,
    color: AppColors.catFun,
  );
  static const health = ExpenseCategory(
    id: 'health',
    label: 'Health',
    icon: Icons.favorite_border,
    color: AppColors.catHealth,
  );
  static const income = ExpenseCategory(
    id: 'income',
    label: 'Income',
    icon: Icons.savings_outlined,
    color: AppColors.accent,
  );
  static const other = ExpenseCategory(
    id: 'other',
    label: 'Other',
    icon: Icons.more_horiz,
    color: AppColors.catOther,
  );

  static const List<ExpenseCategory> expenseCategories = [
    food,
    transport,
    shopping,
    bills,
    fun,
    health,
    other,
  ];

  static const List<ExpenseCategory> all = [
    food,
    transport,
    shopping,
    bills,
    fun,
    health,
    income,
    other,
  ];

  static ExpenseCategory byId(String id) =>
      all.firstWhere((c) => c.id == id, orElse: () => other);
}
