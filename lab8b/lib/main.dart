import 'package:flutter/material.dart';

import 'screens/movie_explorer_screen.dart';

void main() {
  runApp(const MovieExplorerApp());
}

/// App root
class MovieExplorerApp extends StatelessWidget {
  const MovieExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPink = Color(0xFF2D3CD1);
    const Color pinkLight = Color(0xFF2196F3);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Explorer',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPink,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: pinkLight,
          foregroundColor: Colors.black,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
      home: const MovieExplorerScreen(),
    );
  }
}
