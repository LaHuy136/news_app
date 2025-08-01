import 'package:fe_news_app/theme/color_theme.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final Future<void> Function() onLoad;

  const LoadingScreen({super.key, required this.onLoad});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await onLoad();
    });
    return Scaffold(
      backgroundColor: ColorTheme.bgPrimaryColor,
      body: Center(
        child: SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(
            color: ColorTheme.primaryColor,
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
