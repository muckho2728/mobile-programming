import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;


  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Banner (Poster) [cite: 79]
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image.network(
                  movie.imageUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(height: 300, color: Colors.grey),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.black54,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    movie.title,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Genres displayed as Chips [cite: 80, 103]
                  Wrap(
                    spacing: 8.0,
                    children: movie.genres.map((genre) => Chip(label: Text(genre))).toList(),
                  ),
                  const SizedBox(height: 16),

                  // 3. Action Buttons [cite: 82]
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [Icon(Icons.favorite, color: Colors.red), Text("Favorite")]),
                      Column(children: [Icon(Icons.star, color: Colors.amber), Text("Rate")]),
                      Column(children: [Icon(Icons.share, color: Colors.blue), Text("Share")]),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 4. Overview Text [cite: 81]
                  const Text("Storyline", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    movie.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),

                  // 5. Trailers List (Demo UI) [cite: 83]
                  const Text("Trailers", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ListTile(
                    leading: const Icon(Icons.play_circle_fill, size: 40),
                    title: const Text("Official Trailer"),
                    subtitle: const Text("2:30"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.play_circle_fill, size: 40),
                    title: const Text("Teaser"),
                    subtitle: const Text("1:05"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}