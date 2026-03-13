// lib/models/user_model.dart
//
// Model đại diện cho thông tin user trả về từ DummyJSON API
// Dùng để parse JSON response sau khi login thành công

class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String image;       // URL ảnh avatar
  final String accessToken;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.accessToken,
  });

  // Factory constructor: tạo UserModel từ JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      image: json['image'] ?? '',
      accessToken: json['accessToken'] ?? '',
    );
  }

  // Tên đầy đủ
  String get fullName => '$firstName $lastName';
}