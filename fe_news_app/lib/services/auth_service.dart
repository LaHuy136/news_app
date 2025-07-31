// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.38.126:3000/auth';

  static Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'name': name}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Đăng ký thất bại');
    }
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final token = data['token'];

      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      }

      return data;
    } else {
      throw Exception(data['message'] ?? 'Đăng nhập thất bại');
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<bool> requestOTP(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/request-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    return response.statusCode == 200;
  }

  static Future<String> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['message'] ?? 'Đặt lại mật khẩu thành công';
    } else {
      throw Exception(data['message'] ?? 'Đặt lại mật khẩu thất bại');
    }
  }

  static Future<bool> verifyCode(String email, String otp) async {
    final url = Uri.parse('$baseUrl/verify-code');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        print('Lỗi xác minh: ${data['error']}');
        return false;
      }
    } catch (e) {
      print('Lỗi: $e');
      return false;
    }
  }
}
