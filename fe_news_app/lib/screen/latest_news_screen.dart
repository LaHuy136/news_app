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
        title: Text(
          'Tin mới nhất',
          style: TextStyles.textLarge.copyWith(fontWeight: FontWeight.w500),
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
