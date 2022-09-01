import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EmojiController extends GetxController {
  var isEmojiVisible = false.obs;
  FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isEmojiVisible.value = false;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }
}
