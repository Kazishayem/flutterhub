import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterhub/core/resource/constansts/color_manger.dart';
import 'package:flutterhub/core/resource/style_manager.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      onChanged: onChanged,
      style: getRegular400Style14(
        fontSize: 14.sp,
        color: ColorManager.blackColor,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: getRegular400Style14(
          fontSize: 14.sp,
          color: ColorManager.chatTextColor,
        ),
        filled: true,
        fillColor: ColorManager.whiteColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: ColorManager.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: ColorManager.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: ColorManager.textRedColor, width: 1.2),
        ),
      ),
    );
  }
}