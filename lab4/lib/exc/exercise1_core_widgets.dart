import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercise 1 – Core Widgets')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
          Align(
          alignment: Alignment.centerLeft,
          child: Text(
              'Welcome to Flutter UI',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,

                fontWeight: FontWeight.bold,
              ),
            ),
          ),
            SizedBox(height: 16),
            Icon(Icons.movie, color: Colors.blue, size: 80),
            SizedBox(height: 16),
            Image.network(
              'https://image.tmdb.org/t/p/original/Antz70VlRI2yU3iwYxyYUknzfz9.jpg',
              height: 250,
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(Icons.star),
                title: Text('Movie Item'),
                subtitle: Text('This is a sample ListTile inside a Card'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}