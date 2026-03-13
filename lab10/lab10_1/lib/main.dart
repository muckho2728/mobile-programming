// lib/main.dart
//
// Entry point của ứng dụng Lab 10.1 - Mock Login
// Khởi chạy app với LoginScreen là màn hình đầu tiên.

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.1 - Mock Login',
      // Ẩn banner "DEBUG" trên góc phải
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Màn hình đầu tiên khi mở app
      home: LoginScreen(),
    );
  }
}