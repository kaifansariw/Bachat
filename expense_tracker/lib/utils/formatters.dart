import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '\u20B9',
    decimalDigits: 2,
  );

  static String currency(double value) => _currency.format(value);

  static String currencySigned(double value) {
    final formatted = _currency.format(value.abs());
    return value < 0 ? '-$formatted' : '+$formatted';
  }

  static String dayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('EEE, MMM d').format(date);
  }

  static String monthLabel(DateTime date) => DateFormat('MMMM yyyy').format(date);
}
