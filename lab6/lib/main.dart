import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

/*
Step 2 – Define the Movie Model & Sample Data
*/

class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// Sample Data [cite: 67, 68]
final List<Movie> allMovies = [
  Movie(title: 'Inception', year: 2010, genres: ['Action', 'Sci-Fi'], rating: 8.8, posterUrl: 'https://picsum.photos/seed/inception/200/300'),
  Movie(title: 'The Dark Knight', year: 2008, genres: ['Action', 'Drama'], rating: 9.0, posterUrl: 'https://picsum.photos/seed/darkknight/200/300'),
  Movie(title: 'Pulp Fiction', year: 1994, genres: ['Crime', 'Drama'], rating: 8.9, posterUrl: 'https://picsum.photos/seed/pulp/200/300'),
  Movie(title: 'The Matrix', year: 1999, genres: ['Action', 'Sci-Fi'], rating: 8.7, posterUrl: 'https://picsum.photos/seed/matrix/200/300'),
  Movie(title: 'Interstellar', year: 2014, genres: ['Sci-Fi', 'Drama'], rating: 8.6, posterUrl: 'https://picsum.photos/seed/interstellar/200/300'),
  Movie(title: 'The Godfather', year: 1972, genres: ['Crime', 'Drama'], rating: 9.2, posterUrl: 'https://picsum.photos/seed/godfather/200/300'),
];

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const GenreScreen(),
      /*
      Step 3 – Build the Base Scaffold
      */

    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}


class _GenreScreenState extends State<GenreScreen> {
  // State Variables [cite: 78, 83, 91]
  String searchQuery = '';
  Set<String> selectedGenres = {};
  String selectedSort = 'A-Z';

  final List<String> availableGenres = ['Action', 'Drama', 'Sci-Fi', 'Crime', 'Comedy'];

  @override
  Widget build(BuildContext context) {
/*
Step 7 – Filter and Sort the Movie List
*/    List<Movie> visibleMovies = allMovies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesGenre = selectedGenres.isEmpty ||
          movie.genres.any((g) => selectedGenres.contains(g));
      return matchesSearch && matchesGenre;
    }).toList();

    // Sorting [cite: 98, 99]
    if (selectedSort == 'A-Z') {
      visibleMovies.sort((a, b) => a.title.compareTo(b.title));
    } else if (selectedSort == 'Z-A') {
      visibleMovies.sort((a, b) => b.title.compareTo(a.title));
    } else if (selectedSort == 'Year') {
      visibleMovies.sort((a, b) => b.year.compareTo(a.year));
    } else if (selectedSort == 'Rating') {
      visibleMovies.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Find a Movie')), // [cite: 21, 74]
      body: SafeArea( // [cite: 43, 72]
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            /*
            Step 4 – Implement a Responsive Search Bar
            */
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (value) => setState(() => searchQuery = value),
              ),
              const SizedBox(height: 16),

            /*
            Step 5 – Implement Genre Chips Using Wrap 89-96
            */
              const Text('Genres', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: availableGenres.map((genre) {
                  final isSelected = selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selected ? selectedGenres.add(genre) : selectedGenres.remove(genre);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            /*
            Step 6 – Implement Sort Dropdown
            */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Results: ${visibleMovies.length}'),
                  DropdownButton<String>(
                    value: selectedSort,
                    items: ['A-Z', 'Z-A', 'Year', 'Rating'].map((s) {
                      return DropdownMenuItem(value: s, child: Text(s));
                    }).toList(),
                    onChanged: (val) => setState(() => selectedSort = val!),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            /*
            Step 8 – Build a Responsive Movie List (ListView + LayoutBuilder)
            */

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 800) {
                      // Phone Layout: Single Column [cite: 37, 103, 129]
                      return ListView.builder(
                        itemCount: visibleMovies.length,
                        itemBuilder: (context, index) => MovieCard(movie: visibleMovies[index], isGrid: false),
                      );
                    } else {
                      // Tablet/Web Layout: Two Columns [cite: 38, 104, 130]
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: visibleMovies.length,
                        itemBuilder: (context, index) => MovieCard(movie: visibleMovies[index], isGrid: true),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Movie Card Widget [cite: 29-32, 117-120]
class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isGrid;

  const MovieCard({super.key, required this.movie, required this.isGrid});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.posterUrl,
                width: 80,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(movie.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${movie.year} • ${movie.genres.join(", ")}'),
                  Text('Rating: ⭐ ${movie.rating}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}