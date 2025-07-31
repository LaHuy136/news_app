// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:fe_news_app/components/custom_snackbar.dart';
import 'package:fe_news_app/components/elevated_button.dart';
import 'package:fe_news_app/components/text_formfield.dart';
import 'package:fe_news_app/services/auth_service.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  final String code;
  final String email;
  const ResetPassword({super.key, required this.code, required this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPwController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.bgPrimaryColor,
      appBar: AppBar(
        leadingWidth: 55,
        leading: Container(
          margin: EdgeInsets.only(left: 8, top: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: ColorTheme.primaryColor,
          ),
          alignment: Alignment.center,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_rounded, size: 22),
          ),
        ),
        backgroundColor: ColorTheme.bgPrimaryColor,
        foregroundColor: ColorTheme.bgPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cập nhật mật khẩu',
                style: TextStyle(
                  color: ColorTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),

              const SizedBox(height: 50),
              // Password
              MyTextFormField(
                controller: newPasswordController,
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

              const SizedBox(height: 20),
              // Confirm PW
              MyTextFormField(
                controller: confirmPwController,
                hintText: '   Nhập lại mật khẩu',
                isPassword: true,
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

              const SizedBox(height: 25),
              // Button Reset Password
              MyElevatedButton(
                onPressed: () async {
                  final newPassword = newPasswordController.text;
                  final confirmPassword = confirmPwController.text;

                  if (newPassword != confirmPassword) {
                    showCustomSnackBar(
                      context: context,
                      message: 'Mật khẩu không trùng khớp',
                      type: SnackBarType.error,
                    );
                    return;
                  }

                  setState(() => isLoading = true);

                  try {
                    final success = await AuthService.resetPassword(
                      widget.email,
                      widget.code,
                      newPassword,
                    );

                    showCustomSnackBar(
                      context: context,
                      message: 'Cập nhật mật khẩu thành công',
                    );
                    Navigator.pushReplacementNamed(
                      context,
                      '/verificationSuccess',
                    );
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
                textButton: 'Xác nhận',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
