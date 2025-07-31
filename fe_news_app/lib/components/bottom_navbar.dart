// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:fe_news_app/theme/color_theme.dart';
import 'package:flutter/material.dart';

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
                icon:
                    currentRoute == '/home'
                        ? Icons.home_rounded
                        : Icons.home_outlined,
                route: '/home',
                currentRoute: currentRoute,
              ),
              buildNavItem(
                context,
                icon:
                    currentRoute == '/bookmark'
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_outlined,
                route: '/bookmark',
                currentRoute: currentRoute,
              ),
              buildNavItem(
                context,
                icon:
                    currentRoute == '/profile'
                        ? Icons.person_rounded
                        : Icons.person_outline_outlined,
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
    required IconData icon,
    required String route,
    required String? currentRoute,
  }) {
    final isSelected = route == currentRoute;
    final color = isSelected ? ColorTheme.primaryColor : ColorTheme.bodyText;

    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
        ),
        // child: SvgPicture.asset(svgPath, width: 28, height: 28, color: color),
        child: Icon(icon, size: 28, color: color),
      ),
    );
  }
}
