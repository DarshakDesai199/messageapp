import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../view/otp.dart';
import '../view/profile_add.dart';

FirebaseAuth kFirebaseAuth = FirebaseAuth.instance;

class MobileAuthController extends GetxController {
  var isLoading = false;
  TextEditingController mobile = TextEditingController();
  TextEditingController otp = TextEditingController();
  String? verificationCode;

  snackBar(String msg, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg.toString()),
      ),
    );
  }

  sendOtp(BuildContext context) async {
    try {
      isLoading = true;
      update();
      kFirebaseAuth.verifyPhoneNumber(
          phoneNumber: "+91" + mobile.text,
          codeAutoRetrievalTimeout: (String verificationId) {},
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
            print(">>> Verification Complete");
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            verificationCode = verificationId;
            update();
            // print('>>>>>>>>>>> Collection Created');

            Get.to(() => Otp());
            isLoading = false;
            update();
          },
          verificationFailed: (FirebaseAuthException e) {
            isLoading = false;
            update();
            if (e.code == 'invalid-phone-number') {
              snackBar('Invalid MobileNumber', context);
              print('Invalid MobileNumber');
            } else if (e.code == 'missing-phone-number') {
              snackBar('Missing Phone Number', context);
            } else if (e.code == 'user-disabled') {
              snackBar('Number is Disabled', context);
              print('Number is Disabled');
            } else if (e.code == 'quota-exceeded') {
              snackBar('You try too many time. try later ', context);
            } else if (e.code == 'captcha-check-failed') {
              snackBar('Try Again', context);
            }
            print('>>> Verification Failed');
          });
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      update();
      print('$e');
    }
  }

  ///Verify Otp
  verifyOtp(BuildContext context) async {
    try {
      isLoading = true;
      update();
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationCode!, smsCode: otp.text);

      kFirebaseAuth.signInWithCredential(phoneAuthCredential).catchError((e) {
        isLoading = false;
        update();
        if (e.code == 'expired-action-code') {
          snackBar('Code Expired', context);
        } else if (e.code == 'invalid-action-code') {
          snackBar('Invalid Code', context);
        } else if (e.code == 'user-disabled') {
          snackBar('User Disabled', context);
        }
      }).then((value) {
        if (phoneAuthCredential.verificationId!.isEmpty) {
          isLoading = false;
          update();
          snackBar("Enter Valid OTP", context);
        } else {
          // FirebaseFirestore.instance
          //     .collection('user')
          //     .doc(kFirebaseAuth.currentUser!.uid)
          //     .update({'mobile': mobile.text, 'token': token});
          storage.write("mobile", mobile.text);
          Get.off(() => ProfileAdd());
          isLoading = false;
          update();
        }
      });
    } on FirebaseAuthException catch (e) {
    } catch (e) {
      isLoading = false;
      update();
      print(e.toString());
    }
  }

  @override
  void dispose() {
    mobile.dispose();
    otp.dispose();
    super.dispose();
  }
}
