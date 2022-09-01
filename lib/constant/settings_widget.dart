import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'Text.dart';

class SettingWidget extends StatelessWidget {
  final int rotate;
  final String title, subTitle;
  final IconData icons;
  final GestureTapCallback onTap;

  const SettingWidget(
      {super.key,
      required this.rotate,
      required this.title,
      required this.subTitle,
      required this.icons,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.055),
            child: RotatedBox(
                quarterTurns: rotate,
                child: Icon(
                  icons,
                  color: Colors.grey,
                  size: height * 0.026,
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Ts(
                text: title,
                size: height * 0.019,
              ),
              SizedBox(
                height: height * 0.0025,
              ),
              Ts(
                text: subTitle,
                color: Colors.grey,
                size: height * 0.017,
              ),
            ],
          )
        ],
      ),
    );
  }
}
