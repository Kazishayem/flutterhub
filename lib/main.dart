import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/network/api_clients.dart';
import 'core/resource/app_theme_provider.dart';
import 'core/route/route_import_part.dart';
import 'core/route/route_name.dart';
import 'data/sources/local/shared_preference/shared_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool hasSession = await SharedPreferenceData.hasSession();

  if (hasSession) {
    final token = await SharedPreferenceData.getToken();
    await ApiClient.headerSet(token);
  }

  final savedThemeMode = await SharedPreferenceData.getThemeMode();
  final initialThemeMode = _parseThemeMode(savedThemeMode);

  runApp(
    ProviderScope(
      overrides: [initialThemeModeProvider.overrideWithValue(initialThemeMode)],
      child: MyApp(hasSession: hasSession),
    ),
  );
}

ThemeMode _parseThemeMode(String? mode) {
  if (mode == ThemeMode.dark.name) {
    return ThemeMode.dark;
  }
  return ThemeMode.light;
}

class MyApp extends ConsumerWidget {
  final bool hasSession;

  const MyApp({super.key, required this.hasSession});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 840),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: false,
            brightness: Brightness.light,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
            scaffoldBackgroundColor: Colors.white,
            canvasColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: false,
            brightness: Brightness.dark,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            canvasColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          debugShowCheckedModeBanner: false,
          title: 'Iron Ready',
          themeMode: themeMode,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute:
              hasSession
                  ? RouteName.bottomNavbarnRoute
                  : RouteName.signinScreenRoute,
        );
      },
    );
  }
}
