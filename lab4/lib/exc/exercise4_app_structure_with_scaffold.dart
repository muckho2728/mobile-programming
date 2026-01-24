import 'package:flutter/material.dart';

class ScaffoldThemeDemo extends StatefulWidget {
  const ScaffoldThemeDemo({super.key});

  @override
  State<ScaffoldThemeDemo> createState() => _ScaffoldThemeDemoState();

}
class _ScaffoldThemeDemoState extends State<ScaffoldThemeDemo> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Dark Mode control
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      //Light Theme
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      //Dark Theme
      darkTheme: ThemeData.dark(),
      //Screen layout
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Scaffold & Theme'),
          actions: [
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ],
        ),
        body: const Center(
          child: Text(
            'This is a complete screen with Dark Mode',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),

        // floatingActionButton: FloatingActionButton(
        //   child: const Icon(Icons.add),
        //   onPressed: () {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text('FAB Clicked')),
        //     );
        //   },
        // ),
      ),
    );
  }
}

