import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';

/// Service layer: calls REST API and parses data
class ApiService {
  static const String _endpoint =
      'https://jsonplaceholder.typicode.com/posts';

  /// GET list of movies (posts)
  Future<List<Movie>> fetchMovies() async {
    final http.Response response = await http.get(
      Uri.parse(_endpoint),
      headers: const {
        'Accept': 'application/json',
        'User-Agent': 'FlutterApp',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load movies');
    }

    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    return data
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
