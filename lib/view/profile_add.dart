import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messageapp/constant/image_loading.dart';
import 'package:messageapp/controller/mobile_auth_controller.dart';
import 'package:messageapp/controller/profile_controller.dart';
import 'package:messageapp/controller/user_info_controller.dart';
import 'package:messageapp/view/home/Home.dart';

import '../constant/Text.dart';
import '../constant/color.dart';
import '../main.dart';

class ProfileAdd extends StatefulWidget {
  const ProfileAdd({Key? key}) : super(key: key);

  @override
  State<ProfileAdd> createState() => _ProfileAddState();
}

class _ProfileAddState extends State<ProfileAdd> {
  final picker = ImagePicker();
  File? image;
  final TextEditingController _name = TextEditingController();
  final MobileAuthController _mobileAuthController =
      Get.put(MobileAuthController());
  Future getImage() async {
    final getProfile = await picker.pickImage(source: ImageSource.gallery);
    if (getProfile != null) {
      setState(
        () {
          image = File(getProfile.path);
        },
      );
    }
  }

  Future<String?> uploadFile({File? file, String? filename}) async {
    print("File path:$file");

    try {
      var response = await FirebaseStorage.instance
          .ref("user_image/$filename")
          .putFile(file!);

      var data =
          await response.storage.ref("user_image/$filename").getDownloadURL();
      return data;
    } on firebase_storage.FirebaseException catch (e) {
      _profileController.falseI();
      print("ERROR===>>$e");
    }
    return null;
  }

  Future addUserData() async {
    print('FCM TOKEN ==  ${storage.read('fcm')}');
    _profileController.trueI();
    String? userImage = await uploadFile(
        file: image, filename: "${kFirebaseAuth.currentUser?.uid}");
    storage.write('Imgs', userImage);
    storage.write('usernames', _name.text);

    FirebaseFirestore.instance
        .collection('user')
        .doc(kFirebaseAuth.currentUser!.uid)
        .set({
      'mobile': storage.read('mobile'),
      'token': storage.read('fcm'),
      'status': 'Offline',
      'name': _name.text,
      'image': userImage!.isNotEmpty ? userImage : Img,
      'bio': 'Available',
      'time': DateTime.now(),
      'chatroomId': '0'
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  var Img;
  void getUserData() async {
    final user = await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map<String, dynamic>? getUserData = user.data() as Map<String, dynamic>?;
    _name.text = getUserData!['name'];
    setState(() {
      print('>>> ${FirebaseAuth.instance.currentUser!.uid}');
      print('>>>> $Img');
      Img = getUserData['image'];
    });
  }

  final InfoController _infoController = Get.put(InfoController());
  final ProfileController _profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    storage.write('userImage', Img);
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: height * 0.015,
          ),
          Center(
            child: Ts(
                text: "Profile info",
                size: 22,
                weight: FontWeight.w500,
                color: appColor),
          ),
          SizedBox(
            height: height * 0.015,
          ),
          Ts(
            text: "Add your photo and name for your profile",
            size: 18,
          ),
          SizedBox(
            height: height * 0.025,
          ),
          GestureDetector(
            onTap: () {
              getImage();
            },
            child: Container(
              height: height * 0.15,
              width: height * 0.15,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.shade200),
              child: image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(
                        image!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Img != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Img == null
                              ? CircularProgressIndicator(
                                  color: appColor,
                                )
                              : ImageLoading(
                                  url: Img,
                                  hight: height * 0.15,
                                  width: height * 0.15,
                                ),
                        )
                      : Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.grey.shade400,
                          size: height * 0.06,
                        ),
            ),
          ),
          SizedBox(
            height: height * 0.025,
          ),
          SizedBox(
            width: width * 0.9,
            child: TextFormField(
              controller: _name,
              decoration: InputDecoration(
                hintText: "Enter a Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          Spacer(),
          Obx(
            () {
              return _profileController.isLoading.value == false
                  ? SizedBox(
                      width: width * 0.25,
                      height: height * 0.05,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: appColor),
                        onPressed: () {
                          storage.write("username", _name.text);
                          addUserData().then(
                            (value) => Get.offAll(() => Home())!.then(
                              (value) {
                                _profileController.falseI();
                              },
                            ),
                          );
                        },
                        child: Ts(text: "Next", size: 17),
                      ))
                  : CircularProgressIndicator(color: appColor);
            },
          ),
          SizedBox(
            height: height * 0.05,
          ),
        ],
      ),
    ));
  }
}
