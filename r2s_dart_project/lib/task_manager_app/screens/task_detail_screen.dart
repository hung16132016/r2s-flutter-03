import 'package:flutter/material.dart';
import '../../task_manager_app/db/task_database.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../models/enums.dart';
import '../models/task.dart';
import '../utils/date_formatter.dart';
import 'add_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  Future<void> _deleteTask(int? id) async {
    if (id == null) return;
    await TaskDatabase().deleteTask(id) > 0;
  }

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

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  String _getStatusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.overdue:
        return 'Overdue';
    }
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: AppSpacing.verticalSm,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.greyMedium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor ?? AppColors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openEditScreen(BuildContext context) async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => AddTaskScreen(task: task)));
    if (result == true) {
      Navigator.of(context).pop(true);
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.darkGray,
        title: Text('Delete Task', style: TextStyle(color: AppColors.white)),
        content: Text(
          'Are you sure you want to delete this task?',
          style: TextStyle(color: AppColors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: AppColors.white70)),
          ),
          TextButton(
            onPressed: () {
              _deleteTask(task.id);
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseBlack,
      appBar: AppBar(
        title: const Text(
          'Task Details',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.darkGray,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.blue),
            onPressed: () => _openEditScreen(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.red),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              AppSpacing.gapSm,

              // Status chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(task.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getStatusColor(task.status)),
                ),
                child: Text(
                  _getStatusLabel(task.status).toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(task.status),
                  ),
                ),
              ),
              AppSpacing.gapMd,

              // Description section
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white70,
                ),
              ),
              AppSpacing.gapXs,
              Container(
                width: double.infinity,
                padding: AppSpacing.allSm,
                decoration: BoxDecoration(
                  color: AppColors.darkGray,
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                  border: Border.all(color: AppColors.greyDark),
                ),
                child: Text(
                  task.description.isNotEmpty
                      ? task.description
                      : 'No description',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.white60,
                  ),
                ),
              ),
              AppSpacing.gapLg,

              // Details card
              Container(
                padding: AppSpacing.allMd,
                decoration: BoxDecoration(
                  color: AppColors.darkGray,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  border: Border.all(color: AppColors.greyDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Task Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    AppSpacing.gapSm,
                    Divider(color: AppColors.greyDark, height: 1),
                    AppSpacing.gapMd,
                    _buildDetailRow('Category:', task.category),
                    _buildDetailRow(
                      'Priority:',
                      _getPriorityLabel(task.priority),
                      valueColor: _getPriorityColor(task.priority),
                    ),
                    _buildDetailRow(
                      'Due Date:',
                      DateFormatter.formatDate(task.dueDate),
                      valueColor: task.dueDate.isBefore(DateTime.now())
                          ? AppColors.red
                          : AppColors.white70,
                    ),
                    _buildDetailRow(
                      'Created:',
                      DateFormatter.formatDate(task.createdAt),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
