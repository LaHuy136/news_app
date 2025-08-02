import 'package:fe_news_app/components/elevated_button.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:flutter/material.dart';

class CustomDialogContent extends StatefulWidget {
  final String title;
  final Color? backgroundColorIcon;
  final String buttonText;
  final VoidCallback onPressed;
  final ValueChanged<bool> onRememberMeChanged;
  const CustomDialogContent({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColorIcon,
    required this.onRememberMeChanged,
  });

  @override
  State<CustomDialogContent> createState() => _CustomDialogContentState();
}

class _CustomDialogContentState extends State<CustomDialogContent> {
  @override
  Widget build(BuildContext context) {
    bool rememberLogin = true;
    return Dialog(
      backgroundColor: ColorTheme.bgPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: ColorTheme.disableInput),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: ColorTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),

                // Checkbox
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: rememberLogin,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      activeColor: ColorTheme.primaryColor,
                      onChanged: (val) {
                        setState(() {
                          rememberLogin = val ?? false;
                          widget.onRememberMeChanged(rememberLogin);
                        });
                      },
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Ghi nhớ thông tin đăng nhập',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Logout button
                MyElevatedButton(
                  onPressed: widget.onPressed,
                  textButton: widget.buttonText,
                ),

                const SizedBox(height: 18),

                // Cancel button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Hủy',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
