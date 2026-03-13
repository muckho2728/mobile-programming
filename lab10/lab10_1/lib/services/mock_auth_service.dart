// lib/services/mock_auth_service.dart


class MockAuthService {
  // Tài khoản hợp lệ (hardcode để test)
  static const String _validEmail = 'user@test.com';
  static const String _validPassword = '123456';

  /// Giả lập gọi API login
  /// - Nếu đúng email/password → trả về token giả
  /// - Nếu sai → trả về null
  Future<String?> login(String email, String password) async {
    // Giả lập độ trễ mạng (1.5 giây)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (email.trim() == _validEmail && password == _validPassword) {
      // Trả về token giả (trong thực tế token này đến từ server)
      return 'mock_token_xyz_${DateTime.now().millisecondsSinceEpoch}';
    }

    // Sai thông tin → trả về null
    return null;
  }
}
//
// Mục đích: Giả lập quá trình xác thực backend.
// Thay vì gọi API thật, ta dùng dữ liệu hardcode + delay để mô phỏng.