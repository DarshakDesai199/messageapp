import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/mobile_auth_controller.dart';
import '../main.dart';
import 'color.dart';

class CommonContainer extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> message;
  final String uid;
  final Widget child;

  const CommonContainer(
      {super.key,
      required this.message,
      required this.child,
      required this.uid});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: message['isRemove'] == false
          ? Colors.transparent
          : message['sendBy'] == kFirebaseAuth.currentUser!.uid
              ? appColor.withOpacity(0.4)
              : Colors.transparent,
      alignment: message['sendBy'] == kFirebaseAuth.currentUser!.uid
          ? Alignment.topRight
          : Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: message['type'] == 'img' ? 0 : width * 0.035,
            vertical: message['type'] == 'img' ? 0 : height * 0.008),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: height * 0.01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            topLeft: message['sendBy'] == kFirebaseAuth.currentUser!.uid
                ? Radius.circular(12)
                : Radius.circular(0),
            bottomRight: Radius.circular(12),
            topRight: message['sendBy'] == kFirebaseAuth.currentUser!.uid
                ? Radius.circular(0)
                : Radius.circular(12),
          ),
          color: message['sendBy'] == kFirebaseAuth.currentUser!.uid
              ? appColor.withOpacity(0.2)
              : Colors.white,
        ),
        child: child,
      ),
    );
  }
}
