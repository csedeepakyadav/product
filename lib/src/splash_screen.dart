import 'dart:async';
import 'package:flutter/material.dart';
import 'package:product/src/routes/route_generator.dart';
import 'package:product/src/routes/screen_routes.dart';
import 'package:product/src/utils/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double iconSize = 0.0;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        iconSize = 0.2;
      });
    });
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, ScreenRoute.homeScreenRoute);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   SizeConfig().init(context);
    var height = SizeConfig.screenHeight;
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          width: height! * iconSize,
          height: height * iconSize,
          child: ClipOval(
            child: Image.asset(
              "assets/images/splash.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
