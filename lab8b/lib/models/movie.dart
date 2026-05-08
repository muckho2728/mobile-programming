/// Movie model mapped from API JSON
class Movie {
  final int id;
  final String title;
  final String body;

  const Movie({
    required this.id,
    required this.title,
    required this.body,
  });

  /// Convert JSON map to Movie object
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
