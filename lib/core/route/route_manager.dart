part of "route_import_part.dart";

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      //  case RouteName.loadingScreenRoute:
      //   return MaterialPageRoute(builder: (_) => LoadingScreen());

      // case RouteName.splashRoute:
      //   return MaterialPageRoute(builder: (_) => SplashScreen());


      case RouteName.signinScreenRoute:
        return MaterialPageRoute(builder: (_) => const SigninScreen());

      case RouteName.productScreenRoute:
        return MaterialPageRoute(builder: (_) => const ProductScreen());

        case RouteName.postScreenRoute:
        return MaterialPageRoute(builder: (_) => const PostScreen());

        case RouteName.settingScreennRoute:
        return MaterialPageRoute(builder: (_) => const SettingScreen());

      case RouteName.bottomNavbarnRoute:
        return MaterialPageRoute(builder: (_) => const BottomNavbar());
       


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
