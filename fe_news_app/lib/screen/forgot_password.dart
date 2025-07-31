import 'package:fe_news_app/components/elevated_button.dart';
import 'package:fe_news_app/components/radio_option.dart';
import 'package:fe_news_app/screen/forgot_password_enter.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:fe_news_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  ContactOption selectedOption = ContactOption.email;

  void handleConfirm() {
    if (selectedOption == ContactOption.email) {
      // Gửi OTP qua email
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordEnter(contactOption: 'Địa chỉ email'),
        ),
      );
    } else {
      // Gửi OTP qua số điện thoại
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordEnter(contactOption: 'Số di động'),
        ),
      );
    }
  }

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
      body: Padding(
        padding: EdgeInsets.all(16),
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
              'Đừng lo lắng! Điều đó vẫn thường xảy ra. Vui lòng chọn email hoặc số điện thoại được liên kết với tài khoản của bạn.',
              style: TextStyles.textMedium,
            ),

            const SizedBox(height: 12),
            RadioOptionSelector(
              selectedOption: selectedOption,
              onChanged: (option) {
                setState(() {
                  selectedOption = option;
                });
              },
            ),

            Spacer(),
            MyElevatedButton(
              onPressed: handleConfirm,
              textButton: 'Xác nhận',
            ),
          ],
        ),
      ),
    );
  }
}
