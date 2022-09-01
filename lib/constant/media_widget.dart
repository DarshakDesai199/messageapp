import 'package:flutter/material.dart';

import '../main.dart';
import 'Text.dart';

class MediaWidget extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color color;
  final GestureTapCallback onTap;

  MediaWidget(
      {super.key,
      required this.icon,
      required this.name,
      required this.color,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: color,
            radius: height * 0.034,
            child: Icon(icon, color: Colors.white),
          ),
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Ts(
          text: name,
          color: Colors.grey.shade700,
        )
      ],
    );
  }
}
