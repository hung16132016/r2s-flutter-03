import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../models/task.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/search_delegate.dart';
import '../widgets/task_item.dart';
import '../db/task_database.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _listKey = GlobalKey<AnimatedListState>();
  final List<Task> _animatedTasks = [];
  bool _isLoading = true;
  String _searchQuery = '';
  TaskStatus? _filterStatus;
  String? _filterCategory;
  TaskPriority? _filterPriority;

  SortType? _currentSort;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _loadTasksAnimated();
  }

  Future<void> _loadTasksAnimated() async {
    try {
      final tasks = await TaskDatabase().getTasks();
      _animatedTasks.clear();
      for (int i = 0; i < tasks.length; i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        _animatedTasks.add(tasks[i]);
        if (_listKey.currentState?.mounted == true) {
          _listKey.currentState?.insertItem(i);
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int _priorityValue(TaskPriority p) {
    switch (p) {
      case TaskPriority.high:
        return 3;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.low:
        return 1;
    }
  }

  List<Task> _applySort(List<Task> tasks) {
    if (_currentSort == null) return tasks;

    tasks.sort((a, b) {
      int result = 0;
      switch (_currentSort!) {
        case SortType.createdDate:
          result = a.createdAt.compareTo(b.createdAt);
          break;
        case SortType.dueDate:
          result = a.dueDate.compareTo(b.dueDate);
          break;
        case SortType.priority:
          result = _priorityValue(
            a.priority,
          ).compareTo(_priorityValue(b.priority));
          break;
      }
      return _isAscending ? result : -result;
    });

    return tasks;
  }

  List<Task> get _filteredTasks {
    final list = _animatedTasks.where((task) {
      final matchesSearch =
          _searchQuery.isEmpty ||
              task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              task.description.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus =
          _filterStatus == null || task.status == _filterStatus;

      final matchesCategory =
          _filterCategory == null ||
              _filterCategory!.isEmpty ||
              task.category == _filterCategory;

      final matchesPriority =
          _filterPriority == null || task.priority == _filterPriority;

      return matchesSearch &&
          matchesStatus &&
          matchesCategory &&
          matchesPriority;
    }).toList();

    return _applySort(list);
  }

  void _openFilterSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FilterBottomSheet(
        currentStatus: _filterStatus,
        currentCategory: _filterCategory,
        currentPriority: _filterPriority,
        currentSort: _currentSort,
      ),
    );

    if (result != null) {
      setState(() {
        _filterStatus = result['status'];
        _filterCategory = result['category'];
        _filterPriority = result['priority'];
        _currentSort = result['sort'];
      });
    }
  }

  void _openTaskDetail(Task task) async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)));
    if (result == true) _loadTasksAnimated();
  }



  Future<void> _updateTaskStatus(Task task, bool completed) async {
    final updatedTask = task.copyWith(
      status: completed ? TaskStatus.completed : TaskStatus.pending,
    );
    final success = await TaskDatabase().updateTask(updatedTask) > 0;
    if (success) {
      final index = _animatedTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) setState(() => _animatedTasks[index] = updatedTask);
    }
  }

  Widget _buildAnimatedTaskItem(Task task, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: TaskItem(
        task: task,
        onTap: () => _openTaskDetail(task),
        onCheckboxChanged: (value) => _updateTaskStatus(task, value ?? false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: AppColors.baseBlack,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(_animatedTasks),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilterSheet,
          ),
          IconButton(
            icon: Icon(
              _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
            ),
            onPressed: () {
              setState(() {
                _isAscending = !_isAscending;
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.darkGray,
            child: Row(
              children: [
                _buildFilterTab('All', null),
                _buildFilterTab('Pending', TaskStatus.pending),
                _buildFilterTab('Completed', TaskStatus.completed),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                children: [
                  if (_filterStatus != null ||
                      _filterCategory != null ||
                      _filterPriority != null)
                    Container(
                      padding: AppSpacing.allXs,
                      color: Colors.grey[100],
                      child: Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: 4,
                        children: [
                          if (_filterStatus != null)
                            Chip(
                              label: Text('Status: ${_filterStatus!.name}'),
                              backgroundColor: Colors.blue[100],
                              onDeleted: () {
                                setState(() => _filterStatus = null);
                              },
                            ),
                          if (_filterCategory != null)
                            Chip(
                              label: Text('Category: $_filterCategory'),
                              backgroundColor: Colors.green[100],
                              onDeleted: () {
                                setState(() => _filterCategory = null);
                              },
                            ),
                          if (_filterPriority != null)
                            Chip(
                              label: Text('Priority: ${_filterPriority!.name}'),
                              backgroundColor: Colors.orange[100],
                              onDeleted: () {
                                setState(() => _filterPriority = null);
                              },
                            ),
                        ],
                      ),
                    ),

                  if (_currentSort != null)
                    Container(
                      padding: AppSpacing.allXs,
                      color: Colors.grey[50],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sort,
                            size: 16,
                            color: AppColors.purplePrimary,
                          ),
                          AppSpacing.gapXs,
                          Text(
                            'Sorted by: ${_sortTypeToString(_currentSort!)} ${_isAscending ? '↑' : '↓'}',
                            style: TextStyle(
                              color: AppColors.purplePrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (_currentSort != SortType.dueDate)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _currentSort = SortType.dueDate;
                                  _isAscending = true;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '(Reset to default)',
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                  Expanded(
                    child: _filteredTasks.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 64,
                            color: AppColors.grey,
                          ),
                          AppSpacing.gapSm,
                          Text(
                            'No tasks found',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.grey,
                            ),
                          ),
                          AppSpacing.gapXs,
                          Text(
                            'Try changing your filters',
                            style: TextStyle(color: AppColors.grey),
                          ),
                        ],
                      ),
                    )
                        : AnimatedList(
                      key: _listKey,
                      initialItemCount: _filteredTasks.length,
                      itemBuilder: (context, index, animation) {
                        if (index >= _filteredTasks.length)
                          return Container();
                        final task = _filteredTasks[index];
                        return _buildAnimatedTaskItem(task, animation);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.purplePrimary,
        foregroundColor: AppColors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddTaskScreen()));
          if (result == true) _loadTasksAnimated();
        },
      ),
    );
  }

  Widget _buildFilterTab(String label, TaskStatus? status) {
    final isSelected = _filterStatus == status;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _filterStatus = status),
        child: Container(
          padding: AppSpacing.verticalSm,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? AppColors.purplePrimary
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.purplePrimary : AppColors.grey,
            ),
          ),
        ),
      ),
    );
  }

  String _sortTypeToString(SortType type) {
    switch (type) {
      case SortType.createdDate:
        return 'Created Date';
      case SortType.dueDate:
        return 'Due Date';
      case SortType.priority:
        return 'Priority';
    }
  }
}