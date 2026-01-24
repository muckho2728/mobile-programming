import 'package:flutter/material.dart';

class LayoutDemo extends StatelessWidget {
  final List<String> movies = [
    'Avatar',
    'Inception',
    'Interstellar',
    'Joker',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercise 3 – Layout Basics')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child:Text(
              "Now Playing",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded( // Fix ListView inside Column
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.purple.shade100,
                        child: Text(
                          movies[index][0], // lấy chữ cái đầu
                          style: TextStyle(
                            color: Colors.purple.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(movies[index],style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('Sample description'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}