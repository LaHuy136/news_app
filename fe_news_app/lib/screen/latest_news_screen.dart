import 'package:fe_news_app/screen/news_category_screen.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:fe_news_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class LatestNewsScreen extends StatelessWidget {
  const LatestNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.bgPrimaryColor,
      appBar: AppBar(
        backgroundColor: ColorTheme.bgPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_outlined, size: 18),
        ),
        title: Text(
          'Tin mới nhất',
          style: TextStyles.textMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height, 
        child: NewsCategoryScreen(),
      ),
    );
  }
}
