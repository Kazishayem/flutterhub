import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterhub/core/resource/constansts/color_manger.dart';
import 'package:flutterhub/core/resource/constansts/icon_manager.dart';
import 'package:flutterhub/core/resource/style_manager.dart';

class CommonHeader extends StatelessWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onLanguageTap;
  final bool showBack;
  final bool showLanguage;
  final String languageText;

  const CommonHeader({
    super.key,
    this.onBackTap,
    this.onLanguageTap,
    this.showBack = true,
    this.showLanguage = true,
    this.languageText = "BN",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showBack)
          InkWell(
            onTap: onBackTap ?? () => Navigator.pop(context),
            child: Image.asset(
              IconManager.arrowleft,
              height: 20.h,
              width: 20.w,
              fit: BoxFit.contain,
            ),
          ),

        if (showLanguage) ...[
          SizedBox(width: 12.w),
          InkWell(
            onTap: onLanguageTap,
            child: Container(
              width: 50.w,
              height: 30.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: ColorManager.textRedColor,
              ),
              child: Text(
                languageText,
                style: getMedium500Style14(
                  fontSize: 14.sp,
                  color: ColorManager.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}