// ignore_for_file: use_build_context_synchronously

import 'package:fe_news_app/components/custom_snackbar.dart';
import 'package:fe_news_app/components/elevated_button.dart';
import 'package:fe_news_app/components/text_formfield.dart';
import 'package:fe_news_app/screen/verification_code.dart';
import 'package:fe_news_app/services/auth_service.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:fe_news_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class ForgotPasswordEnter extends StatefulWidget {
  final String contactOption;
  const ForgotPasswordEnter({super.key, required this.contactOption});

  @override
  State<ForgotPasswordEnter> createState() => _ForgotPasswordEnterState();
}

class _ForgotPasswordEnterState extends State<ForgotPasswordEnter> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController contactOptionController = TextEditingController();
  bool isLoading = false;
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
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quên mật khẩu',
                style: TextStyle(
                  color: ColorTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),

              const SizedBox(height: 4),
              Text(
                'Đừng lo lắng! Điều đó vẫn thường xảy ra. Vui lòng nhập địa chỉ được liên kết với tài khoản của bạn.',
                style: TextStyles.textMedium,
              ),

              const SizedBox(height: 12),
              // TextField
              Text(widget.contactOption),
              const SizedBox(height: 8),
              MyTextFormField(
                controller: contactOptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ${widget.contactOption}';
                  }
                  return null;
                },
                hintText: '',
              ),

              Spacer(),
              MyElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  setState(() => isLoading = true);

                  try {
                    final ok = await AuthService.requestOTP(
                      contactOptionController.text,
                    );
                    if (ok) {
                      showCustomSnackBar(
                        context: context,
                        message: 'Đã gửi mã OTP',
                      );
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => VerificationCode(
                              email: contactOptionController.text,
                              isForgotPw: true,
                            ),
                      ),
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
