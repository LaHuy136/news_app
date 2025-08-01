// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:fe_news_app/models/user_reponse.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GoogleService {
  static Future<UserResponse?> signInWithGoogle() async {
    try {
      // 1. Google Sign-In qua Firebase
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // user hủy

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw Exception('Missing Google ID token');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        print('Đăng nhập thất bại: Firebase user null.');
        return null;
      }

      // 2. Lấy Firebase ID token để gửi lên backend
      final String? firebaseIdToken = await firebaseUser.getIdToken();
      // 3. Gọi backend (theo route mới: nhận idToken)
      final response = await http.post(
        Uri.parse('http://192.168.38.126:3000/auth/google-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': firebaseIdToken}),
      );

      if (response.statusCode != 200) {
        print('Lỗi từ server: ${response.statusCode} - ${response.body}');
        return null;
      }

      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      final userData = responseData['user'];

      if (token == null || userData == null) {
        throw Exception('Phản hồi không đầy đủ từ backend');
      }

      final userResponse = UserResponse.fromJson(userData);

      // 4. Lưu local
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('id', userResponse.id);
      await prefs.setString('username', userResponse.username);
      await prefs.setString('email', userResponse.email);

      return userResponse;
    } catch (e) {
      print('Lỗi đăng nhập Google: $e');
      return null;
    }
  }
}
