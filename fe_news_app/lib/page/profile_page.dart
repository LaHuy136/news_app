// ignore_for_file: deprecated_member_use, use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:fe_news_app/components/bottom_navbar.dart';
import 'package:fe_news_app/components/dialog_content.dart';
import 'package:fe_news_app/page/settings_page.dart';
import 'package:fe_news_app/screen/my_profile.dart';
import 'package:fe_news_app/services/auth_service.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:fe_news_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int userId = 0;
  String userName = '';
  String email = '';
  File? avatar;
  bool rememberMe = true;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = await AuthService.getUserInfor();
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString('avatar_path');

    if (savedPath != null && File(savedPath).existsSync()) {
      avatar = File(savedPath);
    }
    if (user != null) {
      setState(() {
        userId = user['id'] ?? 0;
        email = user['email'] ?? '';
        userName = user['username'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.bgPrimaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorTheme.bgPrimaryColor,
        title: Container(
          margin: EdgeInsets.only(top: 8),
          child: Text(
            'Cài đặt thông tin',
            style: TextStyles.textLarge.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            top: 120,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(56),
                topRight: Radius.circular(56),
              ),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(color: ColorTheme.bgPrimaryColor),
                padding: EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100),
                    // Profile
                    itemProfile(
                      'assets/icons/profile.svg',
                      'Thông tin cá nhân',
                      () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyProfile()),
                        );

                        if (result == true) {
                          loadUserData();
                        }
                      },
                    ),

                    SizedBox(height: 30),
                    // Settings
                    itemProfile(
                      'assets/icons/settings.svg',
                      'Cài đặt',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  Settings(email: email, userId: userId),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),
                    // Logout
                    itemProfile(
                      'assets/icons/log-out.svg',
                      'Đăng xuất',
                      () async {
                        await showDialog(
                          context: context,
                          builder:
                              (_) => CustomDialogContent(
                                title: 'Đăng xuất khỏi ứng dụng?',
                                buttonText: 'Đăng xuất',
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  if (!rememberMe) {
                                    await prefs.remove('token');
                                  }
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  );
                                },
                                onRememberMeChanged: (val) => rememberMe = val,
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Profile góc trái
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: ColorTheme.bgPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Widget nổi
          Positioned(
            top: 90,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.only(
                top: 60,
                bottom: 16,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                color: ColorTheme.bgPrimaryColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(blurRadius: 4, color: ColorTheme.disableInput),
                ],
              ),
              child: Center(
                child: Text(
                  userName,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // Avatar nổi
          Positioned(
            top: 40,
            left: MediaQuery.of(context).size.width / 2 - 50, // căn giữa
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 45,
                backgroundImage:
                    avatar != null
                        ? FileImage(avatar!) as ImageProvider
                        : AssetImage('assets/images/avatar.png'),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: MyBottomNavbar(),
    );
  }

  Widget itemProfile(String svgPath, String item, void Function()? onTap) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // svgPath
            SvgPicture.asset(
              svgPath,
              width: 28,
              height: 28,
              color: ColorTheme.primaryColor,
            ),
            SizedBox(width: 32),
            // item
            Text(
              item,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
