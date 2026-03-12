import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  final http.Client client;
  final String baseUrl =
      "https://jsonplaceholder.typicode.com/posts";

  ApiService({http.Client? client})
      : client = client ?? http.Client();

  Future<List<Post>> fetchPosts() async {
    final response = await client.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }

  Future<Post> createPost(String title, String body) async {
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "title": title,
        "body": body,
      }),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to create post");
    }
  }
}