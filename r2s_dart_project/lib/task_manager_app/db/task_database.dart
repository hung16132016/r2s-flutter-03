import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart' hide TaskStatus;
import '../models/enums.dart';

class TaskDatabase {
  static final TaskDatabase _instance = TaskDatabase._internal();
  static Database? _database;

  TaskDatabase._internal();

  factory TaskDatabase() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2, // Tăng version lên 2
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        categoryId INTEGER,
        priority TEXT NOT NULL DEFAULT 'medium',
        dueDate TEXT,
        status TEXT NOT NULL DEFAULT 'pending',
        createdAt TEXT NOT NULL,
        tags TEXT
        
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Upgrade from version 1 to 2
      await db.execute('''
        CREATE TABLE IF NOT EXISTS categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          color INTEGER NOT NULL
        )
      ''');

      await db.execute('''
        ALTER TABLE tasks ADD COLUMN tags TEXT
      ''');
      await db.execute('''
        ALTER TABLE tasks ADD COLUMN categoryId INTEGER
      ''');
    }
  }

  // Insert a new task
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  // Get tasks với các tùy chọn sort
  Future<List<Task>> getTasks({
    String? filterStatus,
    String? searchQuery,
    String? categoryFilter,
    String? priorityFilter,
    String? sortBy = 'createdAt',
    String? sortOrder = 'DESC',
  }) async {
    final db = await database;

    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    // Filter by status
    if (filterStatus != null && filterStatus != 'all') {
      whereClause += ' AND status = ?';
      whereArgs.add(filterStatus);
    }

    // Search by title or description
    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause += ' AND (title LIKE ? OR description LIKE ?)';
      whereArgs.add('%$searchQuery%');
      whereArgs.add('%$searchQuery%');
    }

    // Filter by category
    if (categoryFilter != null && categoryFilter != 'all') {
      whereClause += ' AND categoryId = ?';
      whereArgs.add(int.tryParse(categoryFilter));
    }

    // Filter by priority
    if (priorityFilter != null && priorityFilter != 'all') {
      whereClause += ' AND priority = ?';
      whereArgs.add(priorityFilter);
    }

    // Sort options
    String orderByClause = _getSortClause(sortBy, sortOrder);

    try {
      final List<Map<String, dynamic>> result = await db.query(
        'tasks',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: orderByClause,
      );

      return result.map((json) => Task.fromMap(json)).toList();
    } catch (e) {
      debugPrint('Error getting tasks: $e');
      return [];
    }
  }

  // Helper method để tạo sort clause
  String _getSortClause(String? sortBy, String? sortOrder) {
    final order = sortOrder?.toUpperCase() == 'ASC' ? 'ASC' : 'DESC';

    switch (sortBy) {
      case 'dueDate':
      // Sort by due date (null values last)
        return '''
          CASE 
            WHEN dueDate IS NULL THEN 1 
            ELSE 0 
          END,
          dueDate $order
        ''';

      case 'priority':
      // Sort by priority (High > Medium > Low)
        return '''
          CASE priority
            WHEN 'high' THEN 1
            WHEN 'medium' THEN 2
            WHEN 'low' THEN 3
            ELSE 4
          END $order,
          createdAt DESC
        ''';

      case 'title':
        return 'title $order, createdAt DESC';

      case 'status':
        return '''
          CASE status
            WHEN 'completed' THEN 1
            WHEN 'inProgress' THEN 2
            WHEN 'pending' THEN 3
            ELSE 4
          END $order,
          createdAt DESC
        ''';

      default: // 'createdAt'
        return 'createdAt $order';
    }
  }


  // Update task
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete task by ID
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // Update task status
  Future<int> updateTaskStatus(int id, TaskStatus status) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'status': status.name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Toggle task completion
  Future<int> toggleTaskCompletion(int id, bool isCompleted) async {
    final db = await database;
    final newStatus = isCompleted ? 'completed' : 'pending';
    return await db.update(
      'tasks',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('categories');
  }

  // Delete all tasks
  Future<int> deleteAllTasks() async {
    final db = await database;
    return await db.delete('tasks');
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}