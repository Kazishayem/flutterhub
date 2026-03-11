part of "route_import_part.dart";

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      //  case RouteName.loadingScreenRoute:
      //   return MaterialPageRoute(builder: (_) => LoadingScreen());

      // case RouteName.splashRoute:
      //   return MaterialPageRoute(builder: (_) => SplashScreen());



       


        // case RouteName.inclineBenchPressScreenRoute:
        // return MaterialPageRoute(builder: (_) => const InclineBenchPressScreen());

      default:
        return unDefineRoute();
    }
  }

  //CartScreen
  static Route<dynamic> unDefineRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text(AppString.noRoute)),
        body: Center(child: Text(AppString.noRoute)),
      ),
    );
  }
}
