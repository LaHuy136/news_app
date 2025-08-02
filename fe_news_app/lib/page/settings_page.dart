// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:fe_news_app/components/custom_snackbar.dart';
import 'package:fe_news_app/screen/verification_code.dart';
import 'package:fe_news_app/services/auth_service.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Settings extends StatefulWidget {
  final int userId;
  final String email;
  const Settings({super.key, required this.email, required this.userId});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.bgPrimaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: ColorTheme.bgPrimaryColor,
          title: Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              'Cài đặt',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          centerTitle: true,
          leadingWidth: 55,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: EdgeInsets.only(left: 8, top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: ColorTheme.primaryColor,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 22,
                color: ColorTheme.bgPrimaryColor,
              ),
            ),
          ),
        ),
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        child: Container(
          height: double.infinity,
          color: ColorTheme.bgPrimaryColor,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Security
                itemSettings('assets/icons/locked.svg', 'Bảo mật', () async {
                  try {
                    final ok = await AuthService.requestOTP(widget.email);
                    if (ok) {
                      showCustomSnackBar(
                        context: context,
                        message: 'Đã gửi mã OTP',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  VerificationCode(email: widget.email),
                        ),
                      );
                    } else {
                      showCustomSnackBar(
                        context: context,
                        message: 'Gửi OTP thất bại, vui lòng thử lại.',
                        type: SnackBarType.error,
                      );
                    }
                  } catch (e) {
                    showCustomSnackBar(
                      context: context,
                      message: 'Lỗi khi gửi OTP: ${e.toString()}',
                      type: SnackBarType.error,
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemSettings(String svgPath, String item, void Function()? onTap) {
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
