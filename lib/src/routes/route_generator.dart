import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product/src/routes/screen_routes.dart';
import 'package:product/src/splash_screen.dart';
import 'package:product/src/views/home_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case ScreenRoute.splashScreenRoute:
        return MaterialPageRoute(builder: (context) => SplashScreen());

      case ScreenRoute.homeScreenRoute:
        return MaterialPageRoute(builder: (context) => HomeScreen());

      default:
        return MaterialPageRoute(builder: (context) => SplashScreen());
    }
  }
}
