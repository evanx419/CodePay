import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:guavapay/pages/intro.dart';
import 'package:guavapay/pages/loading.dart';

import '../utilities/sharedprefernce.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var initdata;
  @override
  void initState() {
    super.initState();

    loaddata().then((value) {
      setState(() {
        initdata = value;
      });
      // print("THIS IS $initdata");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSplashScreen(
          splash: Image.asset(
            "images/guava.png",
            width: 200,
          ),
          duration: 40,
          splashTransition: SplashTransition.scaleTransition,
          nextScreen: initdata == "" ? const IntroPage() : Loading(initdata)),
    );
  }
}
