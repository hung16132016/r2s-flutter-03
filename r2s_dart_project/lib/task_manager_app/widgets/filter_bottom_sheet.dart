import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../models/enums.dart';
import '../models/task.dart';
import '../models/category.dart';

class FilterBottomSheet extends StatefulWidget {
  final TaskStatus? currentStatus;
  final String? currentCategory;
  final TaskPriority? currentPriority;
  final SortType? currentSort;

  const FilterBottomSheet({
    super.key,
    this.currentStatus,
    this.currentCategory,
    this.currentPriority,
    this.currentSort,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late TaskStatus? _selectedStatus;
  late String? _selectedCategory;
  late TaskPriority? _selectedPriority;
  late SortType? _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
    _selectedCategory = widget.currentCategory;
    _selectedPriority = widget.currentPriority;
    _selectedSort = widget.currentSort;
  }

  void _applyFilters() {
    Navigator.of(context).pop({
      'status': _selectedStatus,
      'category': _selectedCategory,
      'priority': _selectedPriority,
      'sort': _selectedSort,
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedStatus = null;
      _selectedCategory = null;
      _selectedPriority = null;
      _selectedSort = null;
    });
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

  Widget _buildCategoryFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Category',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: Category.defaultCategories.map((category) {
            final isSelected = _selectedCategory == category.name;
            return FilterChip(
              label: Text(
                category.name,
                style: TextStyle(
                  color: isSelected ? AppColors.baseBlack : AppColors.white60,
                  fontSize: 14,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedCategory = isSelected ? null : category.name;
                });
              },
              backgroundColor: AppColors.darkGray,
              selectedColor: category.color.withOpacity(0.3),
              checkmarkColor: category.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? category.color : AppColors.greyBorder,
                  width: 1,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        FilterChip(
          label: Text(
            'All Categories',
            style: TextStyle(
              color: _selectedCategory == null
                  ? AppColors.baseBlack
                  : AppColors.white60,
              fontSize: 14,
            ),
          ),
          selected: _selectedCategory == null,
          onSelected: (_) {
            setState(() {
              _selectedCategory = null;
            });
          },
          backgroundColor: AppColors.darkGray,
          selectedColor: AppColors.purplePrimary.withOpacity(0.3),
          checkmarkColor: AppColors.purplePrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: _selectedCategory == null
                  ? AppColors.purplePrimary
                  : AppColors.greyBorder,
              width: 1,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Sort By',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: SortType.values.map((type) {
            final isSelected = _selectedSort == type;
            return ChoiceChip(
              label: Text(
                _sortLabel(type),
                style: TextStyle(
                  color: isSelected ? AppColors.baseBlack : AppColors.white60,
                  fontSize: 14,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedSort = isSelected ? null : type;
                });
              },
              backgroundColor: AppColors.darkGray,
              selectedColor: AppColors.purplePrimary.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.purplePrimary
                      : AppColors.greyBorder,
                  width: 1,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        ChoiceChip(
          label: Text(
            'No Sorting',
            style: TextStyle(
              color: _selectedSort == null
                  ? AppColors.baseBlack
                  : AppColors.white60,
              fontSize: 14,
            ),
          ),
          selected: _selectedSort == null,
          onSelected: (_) {
            setState(() {
              _selectedSort = null;
            });
          },
          backgroundColor: AppColors.darkGray,
          selectedColor: AppColors.purplePrimary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: _selectedSort == null
                  ? AppColors.purplePrimary
                  : AppColors.greyBorder,
              width: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection<T>(
      String title,
      List<T> options,
      T? selectedValue,
      ValueChanged<T?> onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            String label;
            if (option is TaskStatus) {
              label = _statusLabel(option);
            } else if (option is TaskPriority) {
              label = option.name.toUpperCase(); // LOW, MEDIUM, HIGH vẫn ok
            } else if (option is SortType) {
              label = _sortLabel(option);
            } else {
              label = option.toString();
            }


            Color? chipColor;
            if (option is TaskPriority) {
              chipColor = _getPriorityColor(option);
            } else if (option is TaskStatus) {
              chipColor = _getStatusColor(option);
            }

            return FilterChip(
              label: Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.baseBlack : AppColors.white60,
                  fontSize: 14,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onChanged(isSelected ? null : option),
              backgroundColor: AppColors.darkGray,
              selectedColor: chipColor?.withOpacity(0.3) ??
                  AppColors.purplePrimary.withOpacity(0.3),

              checkmarkColor: chipColor ?? AppColors.purplePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? (chipColor ?? AppColors.purplePrimary)
                      : AppColors.greyBorder,
                  width: 1,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  String _sortLabel(SortType type) {
    switch (type) {
      case SortType.createdDate:
        return 'Created Date';
      case SortType.dueDate:
        return 'Due Date';
      case SortType.priority:
        return 'Priority';
    }
  }

  String _statusLabel(TaskStatus status) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.baseBlack,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.greyMedium,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Center(
              child: Text(
                'Filter & Sort Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Status Section
            _buildFilterSection(
              'Status',
              TaskStatus.values,
              _selectedStatus,
                  (value) => setState(() => _selectedStatus = value),
            ),

            // Category Section
            _buildCategoryFilterSection(),

            // Priority Section
            _buildFilterSection(
              'Priority',
              TaskPriority.values,
              _selectedPriority,
                  (value) => setState(() => _selectedPriority = value),
            ),

            // Divider
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 16),
              color: AppColors.greyBorder,
            ),

            // Sort Section
            _buildSortSection(),

            // Buttons
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearFilters,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.white70,
                      side: BorderSide(color: AppColors.greyBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Clear All',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purplePrimary,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}