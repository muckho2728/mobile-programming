import 'dart:convert';
import '../models/user.dart';

class UserRepository {
  Future<List<User>> fetchUsers() async {
    await Future.delayed(Duration(milliseconds: 300));

    final jsonResponse = '''
    [
      {"name": "Alice", "email": "alice@example.com"},
      {"name": "Bob", "email": "bob@example.com"}
    ]
    ''';

    final List decoded = json.decode(jsonResponse);
    return decoded.map((e) => User.fromJson(e)).toList();
  }
}