/*
import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';

import '../color.dart';

class CustomPage extends StatefulWidget {
  final List<String> titles;
  final List<Widget> pages;

  CustomPage({required this.pages, required this.titles,Key? key});

  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF001489),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.chevron_left_outlined),
        ),
        title: Text(
          widget.titles[currentPage],
        ),
      ),
      body: widget.pages[currentPage],
      bottomNavigationBar: FancyBottomNavigation(
        circleColor:   Color(0xFF001489),
        activeIconColor: Colors.white,
        inactiveIconColor: backgroundColor,
        textColor:mainFontColor,
        barBackgroundColor: Color(0xFF001489),
        initialSelection: currentPage,
        onTabChangedListener: (index) {
          setState(() {
            currentPage = index;
          });
        },
        tabs: [
          TabData(
            iconData: Icons.menu_outlined,
            title: "Menü",
            onclick: () {
              setState(() {
                currentPage = 0;
              });
            },
          ),
          TabData(
            iconData: Icons.home_outlined,
            title: "Ana Sayfa",
            onclick: () {
              setState(() {
                currentPage = 1;
              });
            },
          ),
          TabData(
            iconData: Icons.person_outline,
            title: "Profil",
            onclick: () {
              setState(() {
                currentPage = 2;
              });
            },
          ),
        ],
      ),
    );
  }
}


 */

