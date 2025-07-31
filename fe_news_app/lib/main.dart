import 'package:fe_news_app/page/bookmarks_page.dart';
import 'package:fe_news_app/page/profile_page.dart';
import 'package:fe_news_app/screen/forgot_password.dart';
import 'package:fe_news_app/page/home_page.dart';
import 'package:fe_news_app/page/login_page.dart';
import 'package:fe_news_app/page/sign_up_page.dart';
import 'package:fe_news_app/screen/verification_success.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const HomePage(),
        '/signUp': (context) => const SignUp(),
        '/profile': (context) => const Profile(),
        '/forgotPassword': (context) => ForgotPassword(),
        '/bookmark': (context) => BookmarksPage(),
        '/verificationSuccess': (context) => VerificationSuccess(),
      },
    );
  }
}
