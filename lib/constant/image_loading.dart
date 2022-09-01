import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messageapp/constant/color.dart';

Widget ImageLoading({String? url, double? hight, double? width}) {
  return CachedNetworkImage(
    imageUrl: url!,
    height: hight!,
    width: width,
    fit: BoxFit.cover,
    placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
      color: appColor,
    )),
    errorWidget: (context, url, error) =>
        Center(child: CircularProgressIndicator(color: appColor)),
  );
}
