import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'Text.dart';

String? convertDateForm(DateTime tm) {
  DateTime today = new DateTime.now();
  Duration oneDay = new Duration(days: 1);
  Duration twoDay = new Duration(days: 2);
  Duration oneWeek = new Duration(days: 7);
  String? month;
  switch (tm.month) {
    case 1:
      month = "january";
      break;
    case 2:
      month = "february";
      break;
    case 3:
      month = "march";
      break;
    case 4:
      month = "april";
      break;
    case 5:
      month = "may";
      break;
    case 6:
      month = "june";
      break;
    case 7:
      month = "july";
      break;
    case 8:
      month = "august";
      break;
    case 9:
      month = "september";
      break;
    case 10:
      month = "october";
      break;
    case 11:
      month = "november";
      break;
    case 12:
      month = "december";
      break;
  }

  Duration difference = today.difference(tm);
  if (difference.compareTo(Duration(minutes: 1)) < 1) {
    return 'Now';
  } else if (difference.compareTo(Duration(hours: 1)) < 1) {
    // return '${difference.inMinutes} minute';
    return '${DateFormat.jm().format(tm)}';
  } else if (difference.compareTo(oneDay) < 1) {
    return '${DateFormat.jm().format(tm)}';
    // return '${difference.inHours} hours';
  } else if (difference.compareTo(twoDay) < 1) {
    return "yesterday";
  } else if (difference.compareTo(oneWeek) < 1) {
    switch (tm.weekday) {
      case 1:
        return "monday";
      case 2:
        return "tuesday";
      case 3:
        return "wednesday";
      case 4:
        return "thursday";
      case 5:
        return "friday";
      case 6:
        return "saturday";
      case 7:
        return "sunday";
    }
  } else if (tm.year == today.year) {
    return '${tm.day} $month';
  } else {
    return '${tm.day} $month ${tm.year}';
  }
}

class MsgDate extends StatefulWidget {
  const MsgDate({Key? key, this.date}) : super(key: key);
  final date;
  @override
  State<MsgDate> createState() => _MsgDateState();
}

class _MsgDateState extends State<MsgDate> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Ts(
      text: '${convertDateForm(widget.date)}',
      size: height * 0.016,
      color: Colors.grey,
    );
  }
}
