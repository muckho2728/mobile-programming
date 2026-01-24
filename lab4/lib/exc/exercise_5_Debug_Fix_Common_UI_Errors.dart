import 'package:flutter/material.dart';

class Exercise5DebugFix extends StatefulWidget {
  const Exercise5DebugFix({super.key});

  @override
  State<Exercise5DebugFix> createState() => _Exercise5DebugFixState();
}
class _Exercise5DebugFixState extends State<Exercise5DebugFix> {
  final List<String> movies = [
    'Movie A',
    'Movie B',
    'Movie C',
    'Movie D',
  ];

  bool isFavorite = false;
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 – Common UI Errors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Correct ListView inside Column using Expanded',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ///FIX TASK 1: ListView inside Column
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.movie),
                    title: Text(movies[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
