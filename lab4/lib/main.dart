import 'package:flutter/material.dart';
import 'exc/exercise1_core_widgets.dart';
import 'exc/exercise2_input_controls.dart';
import 'exc/exercise3_layout_basics.dart';
import 'exc/exercise4_app_structure_with_scaffold.dart';
import 'exc/exercise_5_Debug_Fix_Common_UI_Errors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      darkTheme: ThemeData.dark(),
      home: HomeScreen(
        isDarkMode: isDarkMode,
        onToggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const HomeScreen({
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lab 4 – Flutter UI'),
        actions: [
          Switch(
            value: isDarkMode,
            onChanged: (_) => onToggleTheme(),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _navCard(context,'Exercise 1 – Core Widgets Demo',CoreWidgetsDemo(),),
          _navCard(context,'Exercise 2 – Input Controls Demo',InputControlsDemo(),),
          _navCard(context,'Exercise 3 – Layout Demo',LayoutDemo(),),
          _navCard(context,'Exercise 4 – App Structure & Theme',ScaffoldThemeDemo(),),
          _navCard(context,'Exercise 5 – Common UI Fixes',Exercise5DebugFix(),),
        ],
      ),
    );
  }

  Widget _navCard(BuildContext context, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // bo tròn nhẹ
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => page),
            );
          },
        ),
      ),
    );
  }

}