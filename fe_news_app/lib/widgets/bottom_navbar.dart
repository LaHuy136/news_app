import 'package:fe_news_app/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fe_news_app/theme/color_theme.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int selectedIndex = 0;


  final List<Widget> pages = [
    HomePage(),
    Center(child: Text('Yêu thích')),
    Center(child: Text('Cá nhân')),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.bgPrimaryColor,
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: ColorTheme.dividerColor, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          backgroundColor: ColorTheme.bgPrimaryColor,
          selectedItemColor: ColorTheme.primaryColor,
          unselectedItemColor: ColorTheme.bodyText,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Yêu thích',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Cá nhân',
            ),
          ],
        ),
      ),
    );
  }
}
