import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterhub/core/resource/constansts/color_manger.dart';
import 'package:flutterhub/core/resource/style_manager.dart';
import 'package:flutterhub/core/route/route_name.dart';
import 'package:flutterhub/presentation/common%20widget/common_header.dart';
import 'package:flutterhub/presentation/common%20widget/custom_text_feld.dart';
import 'package:flutterhub/presentation/common%20widget/primary_button.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 10.h),

                SizedBox(height: 150.h),

                Text(
                  "Login",
                  style: getBold700Style28(
                    fontSize: 28.sp,
                    color: ColorManager.blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 30.h),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email Address",
                    style: getMedium500Style16(
                      fontSize: 16.sp,
                      color: ColorManager.blackColor,
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                CustomTextField(
                  hintText: "you@example.com",
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(height: 20.h),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: getMedium500Style16(
                      fontSize: 16.sp,
                      color: ColorManager.blackColor,
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                CustomTextField(
                  hintText: "12345678",
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(height: 30.h),

                PrimaryButton(
                  backgroundColor: ColorManager.textRedColor,
                  title: 'Login',
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, RouteName.bottomNavbarnRoute);
                  },
                ),

                SizedBox(height: 20.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: getRegular400Style16(
                        fontSize: 16.sp,
                        color: ColorManager.blackColor,
                      ),
                    ),

                    SizedBox(width: 2.w),

                    Text(
                      "Register ",
                      style: getSemiBold600Style16(
                        fontSize: 16.sp,
                        color: ColorManager.textRedColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
