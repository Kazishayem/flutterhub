import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/route/route_import_part.dart';
import 'core/network/api_clients.dart';
import 'core/route/route_name.dart';
import 'data/sources/local/shared_preference/shared_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool hasSession = await SharedPreferenceData.hasSession();

  if (hasSession) {
    final token = await SharedPreferenceData.getToken();
    await ApiClient.headerSet(token);
  }

  runApp(ProviderScope(child: MyApp(hasSession: hasSession)));
}

class MyApp extends StatelessWidget {
  final bool hasSession;

  const MyApp({super.key, required this.hasSession});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 840),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: false,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            canvasColor: const Color(0xFF121212),
          ),
          debugShowCheckedModeBanner: false,
          title: 'Iron Ready',
          themeMode: ThemeMode.system,
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
