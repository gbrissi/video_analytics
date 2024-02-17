import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String stringify() {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
