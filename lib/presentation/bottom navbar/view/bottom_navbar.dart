import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterhub/core/resource/constansts/color_manger.dart';
import 'package:flutterhub/core/resource/constansts/icon_manager.dart';
import 'package:flutterhub/presentation/post/view/post_screen.dart';
import 'package:flutterhub/presentation/product/view/product_screen.dart';
import 'package:flutterhub/presentation/setting/view/setting_screen.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int selectedPage = 0;

  final List<Widget> pages = [ProductScreen(), PostScreen(), SettingScreen()];

  void onPageTapped(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.whiteColor,
      body: pages[selectedPage],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: SalomonBottomBar(
            currentIndex: selectedPage,
            onTap: onPageTapped,
            items: [
              SalomonBottomBarItem(
                icon: Image.asset(
                  IconManager.home,
                  height: 30.h,
                  width: 30.w,
                  fit: BoxFit.contain,
                ),
                title: const Text("Product"),
                selectedColor: ColorManager.textRedColor,
              ),
              SalomonBottomBarItem(
                icon: Image.asset(
                  IconManager.bell,
                  height: 30.h,
                  width: 30.w,
                  fit: BoxFit.contain,
                  color: ColorManager.textRedColor,
                ),
                title: const Text("Post"),
                selectedColor: ColorManager.textRedColor,
              ),
              SalomonBottomBarItem(
                icon: Image.asset(
                  IconManager.home,
                  height: 30.h,
                  width: 30.w,
                  fit: BoxFit.contain,
                  color: ColorManager.textRedColor,
                ),
                title: const Text("Setting"),

                selectedColor: ColorManager.textRedColor,
              ),
              // SalomonBottomBarItem(
              //   icon: Image.asset(
              //     IconManager.bell,
              //     height: 30.h,
              //     width: 30.w,
              //     fit: BoxFit.contain,
              //     color: ColorManager.textRedColor,
              //   ),
              //   title: const Text("Profile"),

              //   selectedColor: ColorManager.textRedColor,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
