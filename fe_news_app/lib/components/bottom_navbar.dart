// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:fe_news_app/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyBottomNavbar extends StatefulWidget {
  const MyBottomNavbar({super.key});

  @override
  State<MyBottomNavbar> createState() => _MyBottomNavbarState();
}

class _MyBottomNavbarState extends State<MyBottomNavbar> {
  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(height: 1, color: ColorTheme.dividerColor),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          color: ColorTheme.bgPrimaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildNavItem(
                context,
                svgPath: 'assets/icons/home.svg',
                route: '/home',
                currentRoute: currentRoute,
              ),
              buildNavItem(
                context,
                svgPath: 'assets/icons/calendar.svg',
                route: '/calendar',
                currentRoute: currentRoute,
              ),
              buildNavItem(
                context,
                svgPath: 'assets/icons/profile.svg',
                route: '/profile',
                currentRoute: currentRoute,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildNavItem(
    BuildContext context, {
    required String svgPath,
    required String route,
    required String? currentRoute,
  }) {
    final isSelected = route == currentRoute;
    final color = isSelected ? ColorTheme.primaryColor : ColorTheme.primaryColor;

    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
        ),
        child: SvgPicture.asset(svgPath, width: 28, height: 28, color: color),
      ),
    );
  }
}
