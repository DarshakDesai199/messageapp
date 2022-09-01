import 'package:country_phone_code_picker/core/country_phone_code_picker_widget.dart';
import 'package:country_phone_code_picker/models/country.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messageapp/constant/color.dart';
import 'package:messageapp/constant/text.dart';
import 'package:messageapp/controller/mobile_auth_controller.dart';
import 'package:messageapp/main.dart';

class PhoneRegistration extends StatefulWidget {
  const PhoneRegistration({Key? key}) : super(key: key);

  @override
  State<PhoneRegistration> createState() => _PhoneRegistrationState();
}

class _PhoneRegistrationState extends State<PhoneRegistration> {
  // final TextEditingController _mobile = TextEditingController();
  MobileAuthController mobileAuthController = Get.put(MobileAuthController());
  @override
  // void dispose() {
  //   mobileAuthController.mobile.dispose();
  //   super.dispose();
  // }
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<MobileAuthController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.015,
                ),
                Center(
                  child: Ts(
                      text: "Enter your mobile number",
                      size: 22,
                      weight: FontWeight.w500,
                      color: appColor),
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Ts(
                  text: "we will need to verify your mobile number",
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
                  child: Row(children: [
                    SizedBox(
                      height: height * 0.072,
                      width: width * .2,
                      child: CountryPhoneCodePicker.withDefaultSelectedCountry(
                        defaultCountryCode: Country(
                            name: 'India', countryCode: 'IN', phoneCode: '+91'),
                        borderRadius: 0,
                        borderWidth: 1,
                        style: TextStyle(fontSize: 18),
                        searchBarHintText: 'Search by name',
                        showPhoneCode: true,
                        showFlag: false,
                        countryPhoneCodeTextStyle: TextStyle(fontSize: 17),
                      ),
                    ),
                    VerticalDivider(
                      color: appColor,
                      thickness: 1.5,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: controller.mobile,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontSize: 17),
                        cursorColor: appColor,
                        cursorHeight: 25,
                        decoration: InputDecoration(
                            counterText: "",
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    )
                  ]),
                ),
                Spacer(),
                controller.isLoading == false
                    ? SizedBox(
                        width: width * 0.25,
                        height: height * 0.05,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: appColor),
                          onPressed: () {
                            controller.sendOtp(context);
                          },
                          child: Ts(text: "Next", size: 17),
                        ))
                    : CircularProgressIndicator(color: appColor),
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
