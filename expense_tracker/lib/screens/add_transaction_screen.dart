import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/category_picker.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  TxType _type = TxType.expense;
  ExpenseCategory _category = ExpenseCategory.food;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _type == TxType.expense
        ? ExpenseCategory.expenseCategories
        : const [ExpenseCategory.income];

    return Scaffold(
      appBar: AppBar(title: const Text('Add transaction')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
          children: [
            // Expense / income toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.paperElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  Expanded(child: _typeButton('Expense', TxType.expense)),
                  Expanded(child: _typeButton('Income', TxType.income)),
                ],
              ),
            ),
            const SizedBox(height: 22),

            Text('Amount', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: AppText.mono.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
              decoration:
                  const InputDecoration(prefixText: '\u20B9 ', hintText: '0.00'),
            ),
            const SizedBox(height: 20),

            Text('Title', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 15),
              decoration: const InputDecoration(hintText: 'e.g. Groceries'),
            ),
            const SizedBox(height: 20),

            Text('Category', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 10),
            CategoryPicker(
              categories: categories,
              selected: _category,
              onSelect: (c) => setState(() => _category = c),
            ),
            const SizedBox(height: 20),

            Text('Date', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.paperElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.line),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 17, color: AppColors.muted),
                    const SizedBox(width: 10),
                    Text(
                      '${_date.day}/${_date.month}/${_date.year}',
                      style: const TextStyle(fontSize: 14.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text('Note (optional)', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 2,
              style: const TextStyle(fontSize: 14.5),
              decoration: const InputDecoration(hintText: 'Add a short note...'),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Save transaction'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeButton(String label, TxType type) {
    final isSelected = _type == type;
    return GestureDetector(
      onTap: () => setState(() {
        _type = type;
        _category = type == TxType.expense ? ExpenseCategory.food : ExpenseCategory.income;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.paper : AppColors.muted,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text.trim());
    final title = _titleController.text.trim();

    if (amount == null || amount <= 0) {
      _showError('Enter a valid amount.');
      return;
    }
    if (title.isEmpty) {
      _showError('Give this transaction a title.');
      return;
    }

    final tx = MoneyTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      date: _date,
      categoryId: _category.id,
      type: _type,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    context.read<ExpenseProvider>().addTransaction(tx);
    Navigator.of(context).pop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.ink),
    );
  }
}
