import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static bool isOverdue(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now());
  }

  static String getRemainingTime(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    if (difference.inDays > 0) {
      return '${difference.inDays} days left';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours left';
    } else {
      return 'Due soon';
    }
  }
}