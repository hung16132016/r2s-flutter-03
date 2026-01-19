import 'package:flutter/material.dart';
import '../../task_manager_app/utils/app_colors.dart';
import '../../task_manager_app/utils/app_spacing.dart';
import '../models/enums.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../utils/validators.dart';
import '../db/task_database.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;

  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  late TaskPriority _selectedPriority;
  late DateTime _selectedDueDate;
  late TaskStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _selectedCategory =
        widget.task?.category ?? Category.defaultCategories.first.name;
    _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
    _selectedDueDate =
        widget.task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _selectedStatus = widget.task?.status ?? TaskStatus.pending;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDueDate = picked);
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    final task = Task(
      id: widget.task?.id,
      title: title,
      description: description,
      category: _selectedCategory,
      priority: _selectedPriority,
      dueDate: _selectedDueDate,
      status: _selectedStatus,
      createdAt: widget.task?.createdAt ?? DateTime.now(),
      
    );

    bool success;
    String message;

    try {
      if (widget.task?.id != null) {
        final rowsAffected = await TaskDatabase().updateTask(task);
        success = rowsAffected > 0;
        message = success ? 'Task updated successfully' : 'Failed to update task';
      } else {
        final newId = await TaskDatabase().insertTask(task);
        success = newId > 0;
        message = success ? 'Task added successfully' : 'Failed to add task';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );

      if (success) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.inProgress:
        return Colors.orange;
      case TaskStatus.pending:
        return Colors.blue;
      case TaskStatus.overdue:
        return Colors.redAccent;
    }
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: AppColors.grey,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: AppSpacing.horizontalSm,
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: TextFormField(
        style: TextStyle(color: AppColors.grey),
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.grey),
          border: InputBorder.none,
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        title: Text(
          widget.task?.title == null ? 'Add Task' : 'Edit Task',
          style: const TextStyle(color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildLabel('Title'),
                AppSpacing.gapXs,
                _buildTextField(
                  controller: _titleController,
                  hint: 'Add a title',
                  validator: (value) =>
                      Validators.validateRequired(value, field: 'Title'),
                ),
                AppSpacing.gapSm,
                _buildLabel('Description'),
                AppSpacing.gapXs,
                _buildTextField(
                  controller: _descriptionController,
                  hint: 'Add a description',
                  maxLines: 5,
                  validator: (value) =>
                      Validators.validateRequired(value, field: 'Description'),
                ),
                AppSpacing.gapSm,
                _buildLabel('Category'),
                AppSpacing.gapXs,
                Container(
                  padding: AppSpacing.horizontalSm,
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    borderRadius: BorderRadius.circular(AppSpacing.xs),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    dropdownColor: AppColors.darkGray,
                    style: TextStyle(color: AppColors.grey),
                    items: Category.defaultCategories
                        .map(
                          (cat) => DropdownMenuItem(
                        value: cat.name,
                        child: Text(
                          cat.name,
                          style: TextStyle(color: AppColors.grey),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                  ),
                ),
                AppSpacing.gapSm,
                _buildLabel('Priority'),
                AppSpacing.gapXs,
                Row(
                  children: TaskPriority.values.map((priority) {
                    String getLabel() {
                      switch (priority) {
                        case TaskPriority.high:
                          return 'High';
                        case TaskPriority.medium:
                          return 'Medium';
                        case TaskPriority.low:
                          return 'Low';
                      }
                    }

                    final color = _getPriorityColor(priority);

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedPriority = priority),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: AppSpacing.verticalSm,
                          decoration: BoxDecoration(
                            color: _selectedPriority == priority
                                ? color.withOpacity(0.2)
                                : AppColors.darkGray,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _selectedPriority == priority
                                  ? color
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.circle,
                                color: color,
                                size: 16,
                              ),
                              AppSpacing.gapXs,
                              Text(
                                getLabel(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey,
                                  fontWeight: _selectedPriority == priority
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                AppSpacing.gapSm,
                _buildLabel('Due Date'),
                AppSpacing.gapXs,
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.darkGray,
                      borderRadius: BorderRadius.circular(AppSpacing.xs),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: AppColors.grey),
                        AppSpacing.gapSm,
                        Text(
                          '${_selectedDueDate.day}/${_selectedDueDate.month}/${_selectedDueDate.year}',
                          style: TextStyle(color: AppColors.grey),
                        ),
                        const Spacer(),
                        if (_selectedDueDate.isBefore(DateTime.now()))
                          Text(
                            'Overdue',
                            style: TextStyle(
                              color: Colors.red[400],
                              fontSize: 12,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                AppSpacing.gapSm,
                _buildLabel('Status'),
                AppSpacing.gapXs,
                Container(
                  padding: AppSpacing.horizontalSm,
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    borderRadius: BorderRadius.circular(AppSpacing.xs),
                  ),
                  child: DropdownButtonFormField<TaskStatus>(
                    initialValue: _selectedStatus,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    dropdownColor: AppColors.darkGray,
                    style: TextStyle(color: AppColors.grey),
                    items: TaskStatus.values
                        .map(
                          (status) => DropdownMenuItem(
                        value: status,
                        child: Row(
                          children: [
                            Icon(
                              status == TaskStatus.completed
                                  ? Icons.check_circle
                                  : status == TaskStatus.inProgress
                                  ? Icons.hourglass_bottom
                                  : Icons.pending,
                              color: _getStatusColor(status),
                              size: 16,
                            ),
                            AppSpacing.gapSm,
                            Text(status.name.toUpperCase()),
                          ],
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedStatus = value);
                      }
                    },
                  ),
                ),
                AppSpacing.gapLg,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purplePrimary,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.xs),
                      ),
                      padding: AppSpacing.verticalMd,
                    ),
                    onPressed: _saveTask,
                    child: Text(
                      widget.task?.title == null ? 'Save Task' : 'Update Task',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                AppSpacing.gapMd,
              ],
            ),
          ),
        ),
      ),
    );
  }
}