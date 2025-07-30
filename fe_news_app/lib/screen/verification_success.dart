import 'package:fe_news_app/components/elevated_button.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:fe_news_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class VerificationSuccess extends StatelessWidget {
  const VerificationSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.bgPrimaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const SizedBox(height: 50),
          // Logo
          Image.asset('assets/images/logo.png', width: 100, height: 100),

          const SizedBox(height: 30),
          // Title
          Text(
            'Chúc mừng',
            style: TextStyles.displayMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),

          // Subtitle
          Text(
            'Tài khoản của bạn đã sẵn sàng để sử dụng',
            style: TextStyles.displayMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),

          Spacer(),
          // Button
          MyElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            textButton: 'Đi tới trang chủ',
          ),
        ],
      ),
    );
  }
}
