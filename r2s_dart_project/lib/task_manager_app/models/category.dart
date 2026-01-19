
import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.color,
  });

  static List<Category> defaultCategories = [
    Category(id: 'work', name: 'Work', color: Colors.blue),
    Category(id: 'study', name: 'Study', color: Colors.green),
    Category(id: 'personal', name: 'Personal', color: Colors.orange),
    Category(id: 'health', name: 'Health', color: Colors.red),
    Category(id: 'other', name: 'Other', color: Colors.grey),
  ];
}