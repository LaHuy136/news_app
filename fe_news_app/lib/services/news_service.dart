// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  static const String baseUrl = 'http://192.168.38.126:3000/news';

  static Future<List<dynamic>> getNewsByCategory(String category) async {
    final url = Uri.parse('$baseUrl/$category');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['items'] is List) {
        return json['items'];
      } else {
        throw Exception('Invalid format: "items" is not a list');
      }
    } else {
      throw Exception('Failed to load news');
    }
  }
}
