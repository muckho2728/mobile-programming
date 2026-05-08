import 'package:flutter/material.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  runApp(const TasklyApp());
}

class TasklyApp extends StatelessWidget {
  const TasklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TaskListScreen(),
    );
  }
}