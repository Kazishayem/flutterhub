import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterhub/core/resource/constansts/color_manger.dart';
import 'package:flutterhub/core/resource/constansts/icon_manager.dart';
import 'package:flutterhub/presentation/bottom%20navbar/viewmodel/bottom_navbar_viewmodel.dart';
import 'package:flutterhub/presentation/post/view/post_screen.dart';
import 'package:flutterhub/presentation/product/view/product_screen.dart';
import 'package:flutterhub/presentation/setting/view/setting_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavbar extends ConsumerWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPage = ref.watch(bottomNavIndexProvider);
    final pages = const [ProductScreen(), PostScreen(), SettingScreen()];

    return Scaffold(
      backgroundColor: ColorManager.whiteColor,
      body: pages[selectedPage],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          child: SalomonBottomBar(
            currentIndex: selectedPage,
            onTap: (index) {
              ref.read(bottomNavIndexProvider.notifier).state = index;
            },
            items: [
              SalomonBottomBarItem(
                icon: Image.asset(
                  IconManager.shop,
                  height: 30.h,
                  width: 30.w,
                  fit: BoxFit.contain,
                  color: ColorManager.errorColor,
                ),
                title: const Text('Product'),
                selectedColor: ColorManager.errorColor,
              ),
              SalomonBottomBarItem(
                icon: Image.asset(
                  IconManager.profile,
                  height: 30.h,
                  width: 30.w,
                  fit: BoxFit.contain,
                  color: ColorManager.textGreenColor,
                ),
                title: const Text('Post'),
                selectedColor: ColorManager.textGreenColor,
              ),
              SalomonBottomBarItem(
                icon: Image.asset(
                  IconManager.setting,
                  height: 30.h,
                  width: 30.w,
                  fit: BoxFit.contain,
                  color: ColorManager.borderColor1,
                ),
                title: const Text('Setting'),
                selectedColor: ColorManager.borderColor1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
