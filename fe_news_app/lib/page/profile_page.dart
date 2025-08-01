// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';

import 'package:fe_news_app/components/bottom_navbar.dart';
import 'package:fe_news_app/components/custom_snackbar.dart';
import 'package:fe_news_app/components/elevated_button.dart';
import 'package:fe_news_app/services/auth_service.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:fe_news_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  File? avatar;

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
        nameController.text = user['username'] ?? '';
        emailController.text = user['email'] ?? '';
      });
    }
  }

  Future<void> pickAndSaveImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();

      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.png';
      final savedImage = await File(
        pickedFile.path,
      ).copy('${appDir.path}/$fileName');

      imageCache.clear();
      imageCache.clearLiveImages();

      setState(() {
        avatar = savedImage;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatar_path', savedImage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.bgPrimaryColor,
      appBar: AppBar(
        backgroundColor: ColorTheme.bgPrimaryColor,
        title: Text(
          'Trang cá nhân',
          style: TextStyles.textLarge.copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),

                    // Avatar
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 60,
                              key: ValueKey(avatar?.path),
                              backgroundImage:
                                  avatar != null
                                      ? FileImage(avatar!) as ImageProvider
                                      : const AssetImage(
                                        'assets/images/avatar.png',
                                      ),
                            ),
                          ),
                          GestureDetector(
                            onTap: pickAndSaveImage,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: ColorTheme.primaryColor,
                              ),
                              margin: const EdgeInsets.only(top: 60),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.photo_camera_outlined,
                                  size: 24,
                                  color: ColorTheme.bgPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Name
                    buildContent('Tên', nameController),

                    const SizedBox(height: 24),

                    // Email
                    buildContent('Địa chỉ email', emailController),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: MyElevatedButton(
              onPressed: () async {
                final success = await AuthService.updateUser(
                  email: emailController.text,
                  username: nameController.text,
                );

                if (success) {
                  showCustomSnackBar(
                    context: context,
                    message: 'Cập nhập thông tin cá nhân thành công',
                  );
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    ModalRoute.withName('/'),
                  );
                } else {
                  showCustomSnackBar(
                    context: context,
                    message: 'Cập nhập thông tin thất bại',
                  );
                }
              },
              textButton: 'Lưu',
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavbar(),
    );
  }

  Widget buildContent(String text, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyles.textSmall.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: ColorTheme.disableInput),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorTheme.disableInput),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            errorBorder: OutlineInputBorder(
              // borderSide: BorderSide(color: ColorTheme.errorInput),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          style: TextStyles.textSmall,
        ),
      ],
    );
  }
}
