import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterhub/core/network/api_clients.dart';
import 'package:flutterhub/core/resource/app_theme_provider.dart';
import 'package:flutterhub/core/resource/constansts/color_manger.dart';
import 'package:flutterhub/core/resource/utils.dart';
import 'package:flutterhub/core/route/route_name.dart';
import 'package:flutterhub/data/sources/local/shared_preference/shared_preference.dart';
import 'package:flutterhub/presentation/setting/viewmodel/setting_viewmodel.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  Future<void> _logout() async {
    ref.read(logoutLoadingProvider.notifier).state = true;

    try {
      await SharedPreferenceData.clearSession();
      await ApiClient.headerSet(null);

      if (!mounted) return;

      Utils.showToast(
        message: 'Logged out successfully',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.signinScreenRoute,
        (route) => false,
      );
    } finally {
      if (mounted) {
        ref.read(logoutLoadingProvider.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(cachedUserProvider);
    final isLogoutLoading = ref.watch(logoutLoadingProvider);
    final themeMode = ref.watch(appThemeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  'Settings',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                _buildUserSection(userAsync),
                SizedBox(height: 20.h),
                _buildThemeSection(isDarkMode),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLogoutLoading ? null : _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.textRedColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(isLogoutLoading ? 'Logging out...' : 'Logout'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserSection(AsyncValue<Map<String, dynamic>?> userAsync) {
    return userAsync.when(
      data: (user) {
        if (user == null) {
          return _sectionCard(child: const Text('No cached user data found'));
        }

        final imageUrl = user['image']?.toString() ?? '';
        final username = user['username']?.toString() ?? 'N/A';
        final firstName = user['firstName']?.toString() ?? '';
        final lastName = user['lastName']?.toString() ?? '';
        final name = ('$firstName $lastName').trim().isEmpty
            ? (user['name']?.toString() ?? 'N/A')
            : ('$firstName $lastName').trim();
        final email = user['email']?.toString() ?? 'N/A';

        return _sectionCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : null,
                child: imageUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.black54)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Info',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Username: $username'),
                    const SizedBox(height: 4),
                    Text('Name: $name'),
                    const SizedBox(height: 4),
                    Text('Email: $email'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () =>
          _sectionCard(child: const Center(child: CircularProgressIndicator())),
      error: (error, _) => _sectionCard(
        child: Text(
          error.toString(),
          style: const TextStyle(color: ColorManager.errorColor),
        ),
      ),
    );
  }

  Widget _buildThemeSection(bool isDarkMode) {
    return _sectionCard(
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text('Switch between Light and Dark mode'),
              ],
            ),
          ),
          Switch(
            value: isDarkMode,
            onChanged: (isDark) {
              ref.read(appThemeProvider.notifier).toggleDarkMode(isDark);
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }
}
