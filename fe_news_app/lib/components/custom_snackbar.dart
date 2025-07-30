import 'package:fe_news_app/theme/color_theme.dart';
import 'package:flutter/material.dart';

enum SnackBarType { normal, success, error, warning }

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  SnackBarType type = SnackBarType.normal,
}) {
  Color backgroundColor;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = ColorTheme.successColor;
      break;
    case SnackBarType.error:
      backgroundColor = ColorTheme.errorColor;
      break;
    case SnackBarType.warning:
      backgroundColor = ColorTheme.warningColor;
      break;
    case SnackBarType.normal:
      backgroundColor = ColorTheme.successColor;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: ColorTheme.bgPrimaryColor,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
