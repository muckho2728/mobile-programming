import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'detail_screen.dart'; //

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(
                movie.imageUrl,
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.movie),
              ),
              title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("⭐ ${movie.rating} • ${movie.genres.join(', ')}"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}