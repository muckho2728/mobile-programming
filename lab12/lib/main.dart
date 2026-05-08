import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const TasklyApp(),
    ),
  );
}

class TasklyApp extends StatelessWidget {
  const TasklyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab12-Le Thi Hai Ha',
      debugShowCheckedModeBanner: false, // ✅ Ex 12.4: Tắt banner DEBUG
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}