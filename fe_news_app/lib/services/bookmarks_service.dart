import 'dart:convert';
import 'package:fe_news_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class BookmarkService {
  static const String baseUrl = 'http://192.168.38.126:3000/bookmarks';
  static Future<Map<String, String>> getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Tạo bookmark mới
  static Future<bool> createBookmark(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/');
    final headers = await getHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    return response.statusCode == 201;
  }

  /// Lấy danh sách bookmark
  static Future<List<dynamic>> getBookmarks() async {
    final url = Uri.parse('$baseUrl/');
    final headers = await getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load bookmarks');
    }
  }

  /// Xoá bookmark
  static Future<bool> deleteBookmark(String link) async {
    final url = Uri.parse('$baseUrl/');
    final headers = await getHeaders();
    final response = await http.delete(
      url.replace(queryParameters: {'link': link}),
      headers: headers,
    );

    return response.statusCode == 200;
  }
}
