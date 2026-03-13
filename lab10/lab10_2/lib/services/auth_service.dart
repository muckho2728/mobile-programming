// lib/services/auth_service.dart
//
// Service gọi REST API thật đến DummyJSON để xác thực người dùng.
// Endpoint: POST https://dummyjson.com/auth/login
//
// Request body: { "username": "...", "password": "..." }
// Response:     { "accessToken": "...", "id": 1, "username": "...", ... }

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

// Custom exception để phân biệt các loại lỗi
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  static const String _baseUrl = 'https://dummyjson.com';

  /// Gọi API đăng nhập
  /// Trả về [UserModel] nếu thành công
  /// Ném [AuthException] nếu thất bại
  Future<UserModel> login(String username, String password) async {
    // Bước 1: Chuẩn bị request
    final uri = Uri.parse('$_baseUrl/auth/login');

    try {
      // Bước 2: Gửi POST request
      final response = await http
          .post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
          'expiresInMins': 30, // Token hết hạn sau 30 phút
        }),
      )
          .timeout(
        const Duration(seconds: 10), // Timeout sau 10 giây
        onTimeout: () => throw AuthException(
          'Kết nối quá thời gian. Kiểm tra internet và thử lại.',
        ),
      );

      // Bước 3: Xử lý response
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Thành công → parse data thành UserModel
        return UserModel.fromJson(data);
      } else if (response.statusCode == 400) {
        // Sai username/password
        throw AuthException('Tên đăng nhập hoặc mật khẩu không đúng.');
      } else {
        // Lỗi server khác
        throw AuthException(
          'Lỗi server (${response.statusCode}). Thử lại sau.',
        );
      }
    } on AuthException {
      rethrow; // Ném lại lỗi đã xử lý
    } catch (e) {
      // Lỗi mạng hoặc lỗi không xác định
      throw AuthException(
        'Không thể kết nối. Kiểm tra kết nối internet của bạn.',
      );
    }
  }
}