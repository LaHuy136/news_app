// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:fe_news_app/components/custom_snackbar.dart';
import 'package:fe_news_app/components/elevated_button.dart';
import 'package:fe_news_app/page/reset_password.dart';
import 'package:fe_news_app/services/auth_service.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:fe_news_app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationCode extends StatefulWidget {
  final String email;
  const VerificationCode({super.key, required this.email});

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  String currentCode = '';
  int resendSeconds = 60;
  bool isResendAvailable = false;
  late Timer resendTimer;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  void startResendTimer() {
    isResendAvailable = false;
    resendSeconds = 60;
    resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendSeconds == 0) {
        setState(() {
          isResendAvailable = true;
        });
        resendTimer.cancel();
      } else {
        setState(() {
          resendSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    resendTimer.cancel();
    super.dispose();
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            // Create your account
            Text(
              'Mã xác thực OTP',
              style: TextStyles.textMedium.copyWith(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 10),
            // Subtil Image
            Text(
              'Nhập mã OTP đã được gửi tới ${widget.email}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 40),
            // Enter code
            PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              keyboardType: TextInputType.number,
              enableActiveFill: true,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12),
                fieldHeight: 60,
                fieldWidth: 50,
                activeColor: ColorTheme.primaryColor,
                selectedColor: ColorTheme.warningColor,
                inactiveColor: ColorTheme.bodyText,
                activeFillColor: ColorTheme.bgPrimaryColor,
                selectedFillColor: ColorTheme.bgPrimaryColor,
                inactiveFillColor: ColorTheme.bgPrimaryColor,
              ),
              onChanged: (value) {
                setState(() {
                  currentCode = value;
                });
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bạn chưa nhận được mã? ',
                  style: TextStyles.textSmall.copyWith(
                    color: ColorTheme.bodyText,
                  ),
                ),
                InkWell(
                  onTap:
                      isResendAvailable
                          ? () async {
                            final ok = await AuthService.requestOTP(
                              widget.email,
                            );
                            if (ok) {
                              showCustomSnackBar(
                                context: context,
                                message: 'Đã gửi mã OTP',
                              );
                              startResendTimer();
                            } else {
                              showCustomSnackBar(
                                context: context,
                                message: 'Gửi mã OTP thất bại',
                                type: SnackBarType.error,
                              );
                            }
                          }
                          : null,
                  child: Text(
                    isResendAvailable
                        ? 'Gửi lại'
                        : 'Gửi lại sau (${resendSeconds}s)',
                    style: TextStyles.textSmall.copyWith(
                      color:
                          isResendAvailable
                              ? ColorTheme.primaryColor
                              : ColorTheme.bodyText,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 60),
            // Button Confirm
            MyElevatedButton(
              onPressed: () async {
                if (currentCode.length == 6) {
                  final success = await AuthService.verifyCode(
                    widget.email,
                    currentCode,
                  );

                  if (success) {
                    showCustomSnackBar(
                      context: context,
                      message: 'Xác thực thành công',
                      type: SnackBarType.success,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ResetPassword(
                              email: widget.email,
                              code: currentCode,
                            ),
                      ),
                    );
                  } else {
                    showCustomSnackBar(
                      context: context,
                      message: 'Mã xác thực không đúng',
                      type: SnackBarType.error,
                    );
                  }
                } else {
                  showCustomSnackBar(
                    context: context,
                    message: 'Mã phải đủ 6 chữ số',
                    type: SnackBarType.error,
                  );
                }
              },
              textButton: 'Xác nhận',
            ),
          ],
        ),
      ),
    );
  }
}
