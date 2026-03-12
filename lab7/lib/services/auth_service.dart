import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String name;
  final String email;

  User({
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
    );
  }
}

class FakeAuthService {
  static const _key = "registered_users";

  static Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data == null) return [];

    final List decoded = jsonDecode(data);
    return decoded.map((e) => User.fromJson(e)).toList();
  }

  static Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
    jsonEncode(users.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  static Future<User?> register({
    required String name,
    required String email,
  }) async {
    final users = await getUsers();

    final exists =
    users.any((user) => user.email == email);

    if (exists) return null;

    final newUser = User(name: name, email: email);
    users.add(newUser);

    await saveUsers(users);

    return newUser;
  }

  static Future<void> deleteUser(String email) async {
    final users = await getUsers();
    users.removeWhere((u) => u.email == email);
    await saveUsers(users);
  }
}