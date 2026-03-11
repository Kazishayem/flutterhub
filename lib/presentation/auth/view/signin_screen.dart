import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterhub/core/resource/constansts/color_manger.dart';
import 'package:flutterhub/core/resource/style_manager.dart';
import 'package:flutterhub/core/resource/utils.dart';
import 'package:flutterhub/core/route/route_name.dart';
import 'package:flutterhub/presentation/auth/viewmodel/signin_viewmodel.dart';
import 'package:flutterhub/presentation/common%20widget/custom_text_feld.dart';
import 'package:flutterhub/presentation/common%20widget/primary_button.dart';

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Utils.showErrorToast(message: 'Username and password are required');
      return;
    }

    final authRepository = ref.read(authRepositoryProvider);
    ref.read(signinLoadingProvider.notifier).state = true;

    try {
      final isSuccess = await authRepository.login(
        username: username,
        password: password,
      );

      if (!mounted) return;

      if (isSuccess) {
        Utils.showToast(
          message: 'Login successful',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.bottomNavbarnRoute,
          (route) => false,
        );
      } else {
        Utils.showErrorToast(message: 'Invalid credentials');
      }
    } catch (error) {
      Utils.showErrorToast(
        message: error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        ref.read(signinLoadingProvider.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(signinLoadingProvider);

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
                  'Login',
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
                    'Username',
                    style: getMedium500Style16(
                      fontSize: 16.sp,
                      color: ColorManager.blackColor,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: _usernameController,
                  hintText: 'emilys',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: getMedium500Style16(
                      fontSize: 16.sp,
                      color: ColorManager.blackColor,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'emilyspass',
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 30.h),
                PrimaryButton(
                  backgroundColor: ColorManager.textRedColor,
                  title: isLoading ? 'Logging in...' : 'Login',
                  textColor: Colors.white,
                  onPressed: isLoading ? null : _handleLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
