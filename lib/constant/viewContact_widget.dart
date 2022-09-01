import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'Text.dart';
import 'color.dart';

class ViewContactWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final GestureTapCallback onTap;

  const ViewContactWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: onTap,
            icon: Icon(
              icon,
              color: appColor,
              size: height * 0.04,
            )),
        Ts(
          text: title,
          size: height * 0.02,
          weight: FontWeight.w500,
        )
      ],
    );
  }
}
