import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:messageapp/main.dart';
import 'package:messageapp/view/home/Home.dart';
import 'package:messageapp/view/phone_auth.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 2),
      () => Get.offAll(
          () => storage.read('mobile') != null ? Home() : PhoneRegistration()
          // PhoneRegistration(),
          ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('TOKENNNNN >>> ${storage.read('fcm')}');
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child:
                    SvgPicture.asset("assets/logo.svg", height: height * 0.2))
          ],
        ),
      ),
    );
  }
}
