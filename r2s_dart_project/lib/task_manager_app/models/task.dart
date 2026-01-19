
import 'enums.dart';

enum TaskPriority { low, medium, high }

class Task {
  final int? id;
  final String title;
  final String description;
  final String category;
  final TaskPriority priority;
  final DateTime dueDate;
  final TaskStatus status;
  final DateTime createdAt;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority.index,
      'dueDate': dueDate.toIso8601String(),
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    category: map['category'],
    priority: TaskPriority.values[map['priority']],
    dueDate: DateTime.parse(map['dueDate']),
    status: TaskStatus.values[map['status']],
    createdAt: DateTime.parse(map['createdAt']),
  );

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    TaskPriority? priority,
    DateTime? dueDate,
    TaskStatus? status,
    DateTime? createdAt,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        priority: priority ?? this.priority,
        dueDate: dueDate ?? this.dueDate,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
}