import 'package:get/get.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;

  trueI() {
    isLoading.value = true;
    update();
  }

  falseI() {
    isLoading.value = false;
    update();
  }
}
