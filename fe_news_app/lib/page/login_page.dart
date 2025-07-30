// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:fe_news_app/components/custom_snackbar.dart';
import 'package:fe_news_app/components/elevated_button.dart';
import 'package:fe_news_app/components/text_formfield.dart';
import 'package:fe_news_app/services/auth_service.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:fe_news_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.bgPrimaryColor,
      appBar: AppBar(
        backgroundColor: ColorTheme.bgPrimaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Name
                  Text(
                    'Xin chào,',
                    style: TextStyle(
                      color: ColorTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // App Subname
                  Text(
                    'Chào mừng bạn quay trở lại',
                    style: TextStyle(
                      color: ColorTheme.bodyText,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Create your account
                  Center(
                    child: const Text(
                      'Tạo tài khoản',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // Email
              MyTextFormField(
                controller: emailController,
                hintText: '  Địa chỉ email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
                icon: Icons.email_rounded,
              ),

              const SizedBox(height: 20),
              // Password
              MyTextFormField(
                controller: pwController,
                isPassword: true,
                hintText: '  Mật khẩu',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu của bạn chưa đủ độ dài';
                  }
                  return null;
                },
                icon: Icons.lock_rounded,
              ),

              const SizedBox(height: 10),
              // Forgot Password?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox.shrink(),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/forgotPassword'),
                    child: Text(
                      'Quên mật khẩu?',
                      style: TextStyles.textXSmall.copyWith(
                        color: ColorTheme.bodyText,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
              // Button Login
              MyElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  setState(() => isLoading = true);

                  try {
                    final data = await AuthService.login(
                      emailController.text.trim(),
                      pwController.text.trim(),
                    );
                    showCustomSnackBar(
                      context: context,
                      message: 'Đăng nhập thành công',
                    );
                    Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
                    showCustomSnackBar(
                      context: context,
                      message: e.toString().replaceFirst('Exception: ', ''),
                      type: SnackBarType.error,
                    );
                  } finally {
                    setState(() => isLoading = false);
                  }
                },
                isLoading: isLoading,
                textButton: 'Đăng nhập',
              ),

              const SizedBox(height: 35),
              // Or Login with
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('—', style: TextStyle(color: ColorTheme.primaryColor)),
                  const SizedBox(width: 6),
                  Text(
                    'hoặc Đăng nhập với',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(width: 6),
                  Text('—', style: TextStyle(color: ColorTheme.primaryColor)),
                ],
              ),

              const SizedBox(height: 20),
              // Social Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Google
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorTheme.dividerColor),
                      ),
                      padding: EdgeInsets.all(16),
                      child: SvgPicture.asset(
                        'assets/icons/google.svg',
                        width: 23,
                        height: 23,
                      ),
                    ),
                  ),

                  const SizedBox(width: 40),
                  // Facebook
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorTheme.dividerColor),
                      ),
                      padding: EdgeInsets.all(16),
                      child: SvgPicture.asset(
                        'assets/icons/facebook.svg',
                        width: 23,
                        height: 23,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bạn chưa có tài khoản?',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/signUp'),
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorTheme.primaryColor,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
