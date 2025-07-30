import 'package:fe_news_app/components/text_formfield.dart';
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
  final TextEditingController contactOptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text('Email / Số điện thoại'),
            const SizedBox(height: 8),
            MyTextFormField(
              controller: contactOptionController,
              hintText: '',
            ),
          ],
        ),
      ),
    );
  }
}
