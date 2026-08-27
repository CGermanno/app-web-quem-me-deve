import 'package:intl/intl.dart';

// Formatação de moeda (R$)
String formatCurrency(double value) {
  final f = NumberFormat.simpleCurrency(locale: 'pt_BR');
  return f.format(value);
}

// Exemplo de formatação de data (pode expandir conforme necessário)
String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy – HH:mm').format(date);
}
