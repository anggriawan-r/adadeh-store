import 'package:intl/intl.dart';

String currencyFormatter(int input) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
  );
  final formattedCurrency = formatter.format(input);

  return formattedCurrency;
}
