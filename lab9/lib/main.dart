import 'package:flutter/material.dart';
import 'screens/screen1.dart';
import 'screens/screen2.dart';
import 'screens/screen3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lab 9 Menu")),
      body: Column(
        children: [
          ElevatedButton(
            child: const Text("Lab 9.1 - Read JSON"),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Screen1()),
            ),
          ),
          ElevatedButton(
            child: const Text("Lab 9.2 - Save JSON"),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Screen2()),
            ),
          ),
          ElevatedButton(
            child: const Text("Lab 9.3 - CRUD JSON"),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Screen3()),
            ),
          ),
        ],
      ),
    );
  }
}