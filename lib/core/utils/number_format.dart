import 'package:intl/intl.dart';

extension NumFormatter on double {
  String toCurrency() {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(this);
  }

  String formatMarketCap() {
    if (this >= 1e12) return '${(this / 1e12).toStringAsFixed(2)} trillion';
    if (this >= 1e9) return '${(this / 1e9).toStringAsFixed(2)} billion';
    if (this >= 1e6) return '${(this / 1e6).toStringAsFixed(2)} million';
    return toStringAsFixed(2);
  }
}
