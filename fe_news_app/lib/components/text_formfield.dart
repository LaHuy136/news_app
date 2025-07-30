import 'package:fe_news_app/theme/color_theme.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;
  final Widget? suffixIcon;
  final IconData? icon;
  final bool? enable;
  final bool isPassword;
  const MyTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.isPassword = false,
    this.enable = true,
    this.suffixIcon,
    this.icon,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? obscureText : false,
      validator: widget.validator,
      style: TextStyle(
        fontSize: 12,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        prefixIconConstraints: const BoxConstraints(
          minHeight: 55,
          minWidth: 55,
        ),
        prefixIcon:
            widget.icon != null
                ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    color: ColorTheme.primaryColor,
                  ),
                  child: Icon(widget.icon, color: ColorTheme.bgPrimaryColor),
                )
                : null,
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                  ),
                  color: ColorTheme.bodyText,
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )
                : widget.suffixIcon,

        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        enabled: widget.enable!,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorTheme.disableInput),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        errorBorder: OutlineInputBorder(
          // borderSide: BorderSide(color: ColorTheme.errorInput),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // borderSide: BorderSide(color: ColorTheme.errorInput),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
