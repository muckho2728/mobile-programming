import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/api_service.dart';

/// Main screen: shows list of movies from API
class MovieExplorerScreen extends StatefulWidget {
  const MovieExplorerScreen({super.key});

  @override
  State<MovieExplorerScreen> createState() => _MovieExplorerScreenState();
}

class _MovieExplorerScreenState extends State<MovieExplorerScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Movie>> _moviesFuture;

  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  static const Color _pink = Color(0xFF2D3CD1);
  static const Color _pinkLight = Color(0xFF2196F3);
  static const Color _pinkSoft = Color(0xFF78BCEF);
  static const Color _textDark = Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Initialize or reload the API call
  void _loadMovies() {
    _moviesFuture = _apiService.fetchMovies();
  }

  /// Retry button action
  void _retry() {
    setState(_loadMovies);
  }

  List<Movie> _filterMovies(List<Movie> movies) {
    final String q = _query.trim().toLowerCase();
    if (q.isEmpty) return movies;
    return movies
        .where((m) =>
    m.title.toLowerCase().contains(q) ||
        m.body.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pinkSoft,
      appBar: AppBar(
        title: const Text('Movie Explore'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Failed to load movies',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please check your connection and try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Success state
          final List<Movie> movies = snapshot.data ?? [];
          if (movies.isEmpty) {
            return const Center(child: Text('No movies found.'));
          }

          final List<Movie> filtered = _filterMovies(movies);

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            itemCount: filtered.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _pinkLight),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search movies...',
                          prefixIcon: const Icon(Icons.search, color: _textDark),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: _pinkLight),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: _pinkLight),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: _pink, width: 1.6),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _query = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                );
              }

              final Movie movie = filtered[index - 1];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _pinkLight),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  title: Text(
                    movie.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        movie.body,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _pinkLight,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'ID: ${movie.id}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
