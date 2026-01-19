import 'package:flutter/material.dart';

enum TaskStatus { pending, inProgress, completed, overdue }
enum Priority { low, medium, high }
enum SortType { createdDate, dueDate, priority }

extension TaskStatusExtension on TaskStatus {
  String get name {
    switch (this) {
      case TaskStatus.pending: return 'Pending';
      case TaskStatus.inProgress: return 'In Progress';
      case TaskStatus.completed: return 'Completed';
      case TaskStatus.overdue: return 'Overdue';

    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.pending: return Colors.orange;
      case TaskStatus.inProgress: return Colors.blue;
      case TaskStatus.completed: return Colors.green;
      case TaskStatus.overdue: return Colors.redAccent;
    }
  }
}

extension PriorityExtension on Priority {
  String get name {
    switch (this) {
      case Priority.low: return 'Low';
      case Priority.medium: return 'Medium';
      case Priority.high: return 'High';
    }
  }

  Color get color {
    switch (this) {
      case Priority.low: return Colors.green;
      case Priority.medium: return Colors.orange;
      case Priority.high: return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case Priority.low: return Icons.arrow_downward;
      case Priority.medium: return Icons.remove;
      case Priority.high: return Icons.arrow_upward;
    }
  }
}