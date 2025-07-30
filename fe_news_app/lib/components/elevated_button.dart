import 'package:fe_news_app/theme/color_theme.dart';
import 'package:flutter/material.dart';

class MyElevatedButton extends StatefulWidget {
  final void Function()? onPressed;
  final String textButton;
  final bool isLoading;
  final bool isCancel;

  const MyElevatedButton({
    super.key,
    required this.onPressed,
    required this.textButton,
    this.isLoading = false,
    this.isCancel = false,
  });

  @override
  State<MyElevatedButton> createState() => _MyElevatedButtonState();
}

class _MyElevatedButtonState extends State<MyElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              widget.isCancel ? Colors.transparent : ColorTheme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child:
            widget.isLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorTheme.primaryColor,
                    ),
                  ),
                )
                : Text(
                  widget.textButton,
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.isCancel ? null : ColorTheme.bgPrimaryColor,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
      ),
    );
  }
}
