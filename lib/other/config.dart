import 'package:intl/intl.dart';

String formatCurrency(num amount) {
  final formatter =
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
  return formatter.format(amount);
}

const String urlLogo = "assets/images/hlphone_logo.png";
