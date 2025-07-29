// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  static const String baseUrl = 'http://192.168.38.126:3000/news';

  static Future<List<dynamic>> getNewsByCategory(String category) async {
    final url = Uri.parse('$baseUrl/$category');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['items']; 
    } else {
      throw Exception('Failed to load news');
    }
  }
}
