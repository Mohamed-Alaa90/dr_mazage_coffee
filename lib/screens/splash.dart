import 'dart:async';

import 'package:dr_mazage_coffee/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Get.offAll(transition: Transition.zoom, () => Home());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff192f45),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 400, height: 400),
            const SizedBox(height: 20),
            LoadingAnimationWidget.hexagonDots(
              color: Color(0XFFd96d16),
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
