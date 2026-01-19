import 'package:flutter/material.dart';
import 'package:r2s_dart_project/task_manager_app/screens/splash_screen.dart';

import '../task_manager_app/screens/onboard_screen.dart';
import '../task_manager_app/screens/home_screen.dart';


void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboard': (context) => const OnboardScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}