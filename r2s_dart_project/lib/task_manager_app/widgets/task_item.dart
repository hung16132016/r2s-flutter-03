import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../models/enums.dart';
import '../models/task.dart';
import '../utils/date_formatter.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final ValueChanged<bool?>? onCheckboxChanged;
  final VoidCallback? onLongPress;

  const TaskItem({
    super.key,
    required this.task,
    required this.onTap,
    this.onCheckboxChanged,
    this.onLongPress,
  });

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.red;
      case TaskPriority.medium:
        return AppColors.orange;
      case TaskPriority.low:
        return AppColors.green;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return AppColors.green;
      case TaskStatus.inProgress:
        return AppColors.orange;
      case TaskStatus.pending:
        return AppColors.blue;
      case TaskStatus.overdue:
        return AppColors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Xác định hiển thị gì (due date hoặc priority)
    Widget trailingWidget;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDueDate = DateTime(
      task.dueDate.year,
      task.dueDate.month,
      task.dueDate.day,
    );

    // Nếu là hôm nay hoặc ngày mai -> hiển thị due date
    if (taskDueDate == today || taskDueDate == tomorrow) {
      trailingWidget = Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: taskDueDate == today ? AppColors.red.withOpacity(0.1) : AppColors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: taskDueDate == today ? AppColors.red.withOpacity(0.1) : AppColors.orange.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Text(
          taskDueDate == today ? 'Today' : 'Tomorrow',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: taskDueDate == today ? AppColors.red : AppColors.orange,
          ),
        ),
      );
    }
    // Nếu hơn 2 ngày -> hiển thị priority
    else {
      final priorityColor = _getPriorityColor(task.priority);
      final priorityLabel = task.priority.name.toUpperCase();

      trailingWidget = Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: priorityColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: priorityColor, width: 1),
        ),
        child: Text(
          priorityLabel,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: priorityColor,
          ),
        ),
      );
    }

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(AppSpacing.xs),
          border: Border.all(color: AppColors.greyBorder),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          leading: Checkbox(
            value: task.status == TaskStatus.completed,
            onChanged: onCheckboxChanged,
            activeColor: _getStatusColor(task.status),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: task.status == TaskStatus.completed
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: task.status == TaskStatus.completed
                  ? AppColors.greyMedium
                  : AppColors.white,
            ),
          ),
          subtitle: task.description.isNotEmpty
              ? Text(
                  task.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.white60,
                    decoration: task.status == TaskStatus.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                )
              : null,
          trailing: trailingWidget,
          onTap: onTap,
        ),
      ),
    );
  }
}
