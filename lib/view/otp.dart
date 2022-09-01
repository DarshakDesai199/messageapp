import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messageapp/controller/mobile_auth_controller.dart';

import '../constant/Text.dart';
import '../constant/color.dart';
import '../main.dart';

class Otp extends StatefulWidget {
  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  // void dispose() {
  //   _mobileAuthController.otp.dispose();
  //   super.dispose();
  // }

  final MobileAuthController _mobileAuthController =
      Get.put(MobileAuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<MobileAuthController>(
          builder: (controller) {
            return Column(
              children: [
                SizedBox(
                  height: height * 0.015,
                ),
                Center(
                  child: Ts(
                      text: "Enter your OTP",
                      size: 22,
                      weight: FontWeight.w500,
                      color: appColor),
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Ts(
                  text: "we will need to verify your otp",
                  size: 18,
                ),
                SizedBox(
                  height: height * 0.025,
                ),
                Container(
                  height: height * 0.072,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: appColor, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: controller.otp,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontSize: 17),
                          cursorColor: appColor,
                          cursorHeight: 25,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 25),
                            counterText: "",
                            hintText: "OTP",
                            hintStyle: TextStyle(
                                fontSize: 18, color: Colors.grey.shade500),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                controller.isLoading == false
                    ? SizedBox(
                        width: width * 0.25,
                        height: height * 0.05,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: appColor),
                          onPressed: () async {
                            // print("+++++++++++Otp Button");
                            controller.verifyOtp(context);
                          },
                          child: Ts(text: "Next", size: 17),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        color: appColor,
                      )),
                SizedBox(
                  height: height * 0.05,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
