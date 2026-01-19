import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/task_detail_screen.dart';
import '../utils/app_colors.dart';

class TaskSearchDelegate extends SearchDelegate<String> {
  final List<Task> tasks;

  TaskSearchDelegate(this.tasks);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkGray,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 16,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: AppColors.white), // màu chữ khi gõ
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: AppColors.white60),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: AppColors.white),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.white),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = tasks.where((task) {
      return task.title.toLowerCase().contains(query.toLowerCase()) ||
          task.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, index) {
        final task = results[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          onTap: () async {
            close(context, task.title);
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TaskDetailScreen(task: task),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
