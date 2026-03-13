// lib/screens/login_screen.dart


import 'package:flutter/material.dart';
import '../services/mock_auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Key để quản lý trạng thái Form (dùng để validate)
  final _formKey = GlobalKey<FormState>();

  // Controller để lấy giá trị từ TextField
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Service xử lý xác thực
  final _authService = MockAuthService();

  // Trạng thái: đang loading hay không
  bool _isLoading = false;

  // Thông báo lỗi (null = không có lỗi)
  String? _errorMessage;

  // Ẩn/hiện password
  bool _obscurePassword = true;

  // Giải phóng bộ nhớ khi widget bị hủy
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Hàm xử lý đăng nhập
  Future<void> _handleLogin() async {
    // Bước 1: Validate tất cả các field trong Form
    if (!_formKey.currentState!.validate()) return;

    // Bước 2: Bắt đầu loading, xóa lỗi cũ
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Bước 3: Gọi service để xác thực
    final token = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    // Bước 4: Xử lý kết quả
    // Kiểm tra widget còn mounted không (tránh lỗi khi navigate)
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (token != null) {
      // Đăng nhập thành công → sang Home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(token: token!),
        ),
      );
    } else {
      // Đăng nhập thất bại → hiện lỗi
      setState(() {
        _errorMessage = 'Email hoặc mật khẩu không đúng.\nVui lòng thử lại.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // Logo / Tiêu đề
              const Icon(
                Icons.lock_outline,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              const Text(
                'Đăng nhập',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Lab 10.1 - Mock Login',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Form chứa các input field
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      // Tắt autocorrect cho email
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'user@test.com',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // Validator: kiểm tra email không trống và đúng định dạng
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập email';
                        }
                        // Kiểm tra định dạng email đơn giản
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Email không hợp lệ';
                        }
                        return null; // null = hợp lệ
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        prefixIcon: const Icon(Icons.lock_outline),
                        // Nút ẩn/hiện password
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // Validator: tối thiểu 6 ký tự
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        if (value.length < 6) {
                          return 'Mật khẩu phải có ít nhất 6 ký tự';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // ── Thông báo lỗi ────────────────────────────────────
                    // Chỉ hiển thị khi có lỗi
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),

                    // ── Nút Login ────────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        // Vô hiệu hóa khi đang loading
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Gợi ý tài khoản test
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '💡 Tài khoản test:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text('Email: user@test.com'),
                    Text('Password: 123456'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// Màn hình Login: Giao diện đăng nhập với Form validation.
// Khi người dùng nhấn Login:
//   1. Validate form (email hợp lệ, password >= 6 ký tự)
//   2. Gọi MockAuthService.login()
//   3. Nếu thành công → navigate sang HomeScreen
//   4. Nếu thất bại → hiển thị thông báo lỗi