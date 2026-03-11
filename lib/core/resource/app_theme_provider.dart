import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/sources/local/shared_preference/shared_preference.dart';

final initialThemeModeProvider = Provider<ThemeMode>((ref) => ThemeMode.light);

final appThemeProvider = StateNotifierProvider<AppThemeNotifier, ThemeMode>(
  (ref) => AppThemeNotifier(ref.read(initialThemeModeProvider)),
);

class AppThemeNotifier extends StateNotifier<ThemeMode> {
  AppThemeNotifier(super.state);

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) {
      return;
    }

    state = mode;
    await SharedPreferenceData.setThemeMode(mode.name);
  }

  Future<void> toggleDarkMode(bool isDark) async {
    await setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
