import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messageapp/constant/image_loading.dart';
import 'package:messageapp/constant/text.dart';
import 'package:messageapp/controller/user_info_controller.dart';
import 'package:messageapp/main.dart';

import '../../../../constant/color.dart';
import '../../../../controller/mobile_auth_controller.dart';
import 'about.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final InfoController _infoController = Get.put(InfoController());
  bool isAppBar = false;
  final picker = ImagePicker();
  final TextEditingController _name = TextEditingController();
  File? image;
  Future getImageGallery() async {
    final getProfile = await picker.pickImage(source: ImageSource.gallery);
    if (getProfile != null) {
      setState(
        () {
          image = File(getProfile.path);
        },
      );
    }
  }

  Future getImageCamera() async {
    final getProfile = await picker.pickImage(source: ImageSource.camera);
    if (getProfile != null) {
      setState(
        () {
          image = File(getProfile.path);
        },
      );
    }
  }

  @override
  void initState() {
    // _infoController;
    _name.text = _infoController.name!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: appColor,
          title: isAppBar
              ? Ts(text: "Profile photo", size: 20)
              : Ts(text: "Profile ", size: 20),
          leading: IconButton(
            onPressed: () {
              isAppBar == false ? Get.back() : null;

              setState(() {
                isAppBar = false;
              });
            },
            icon: Icon(Icons.arrow_back),
          )),
      body: isAppBar == true
          ? GetBuilder<InfoController>(
              builder: (controller) {
                return SafeArea(
                  child: Container(
                    height: height,
                    width: width,
                    color: Colors.black,
                    child: Center(
                      child: Hero(
                        tag: '${controller.Img}',
                        child: Container(
                          height: height * 0.5,
                          width: width,
                          decoration: BoxDecoration(),
                          child: ImageLoading(
                            url: '${controller.Img}',
                            hight: height * 0.5,
                            width: width,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : GetBuilder<InfoController>(
              builder: (controller) {
                return SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.03500,
                      ),
                      Hero(
                        tag: '${controller.Img}',
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isAppBar = true;
                                  });
                                },
                                child: Container(
                                  height: height * 0.2,
                                  width: height * 0.2,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade200),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: ImageLoading(
                                      url: '${controller.Img}',
                                      hight: height * 0.2,
                                      width: height * 0.2,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -height * 0.001,
                                right: -width * 0.0005,
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      backgroundColor: whiteColor,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: height * 0.21,
                                          width: width,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.04),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: height * 0.0200,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Ts(
                                                      text: "Profile photo",
                                                      size: height * 0.022,
                                                      weight: FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('user')
                                                            .doc(kFirebaseAuth
                                                                .currentUser!
                                                                .uid)
                                                            .update(
                                                          {
                                                            'image':
                                                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                                                          },
                                                        );
                                                        controller
                                                            .getUserData();
                                                        Get.back();
                                                      },
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.black38,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height * 0.0100,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            getImageCamera()
                                                                .whenComplete(
                                                              () {
                                                                controller
                                                                    .updateData(
                                                                        image!);
                                                              },
                                                            );
                                                            controller
                                                                .getUserData();

                                                            Get.back();
                                                          },
                                                          child: Container(
                                                            height:
                                                                height * 0.065,
                                                            width:
                                                                height * 0.065,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500)),
                                                            child: Icon(
                                                                Icons
                                                                    .photo_camera,
                                                                size: height *
                                                                    0.032,
                                                                color:
                                                                    appColor),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height * 0.01,
                                                        ),
                                                        Ts(
                                                          text: "Camera",
                                                          color: Colors
                                                              .grey.shade800,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.08,
                                                    ),
                                                    Column(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            getImageGallery()
                                                                .whenComplete(
                                                              () {
                                                                controller
                                                                    .updateData(
                                                                        image!);
                                                                controller
                                                                    .getUserData();

                                                                Get.back();
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            height:
                                                                height * 0.065,
                                                            width:
                                                                height * 0.065,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade500),
                                                            ),
                                                            child: Icon(
                                                                Icons
                                                                    .photo_size_select_actual,
                                                                size: height *
                                                                    0.032,
                                                                color:
                                                                    appColor),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height * 0.01,
                                                        ),
                                                        Ts(
                                                          text: "Gallery",
                                                          color: Colors
                                                              .grey.shade800,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: height * 0.055,
                                    width: height * 0.055,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: appColor,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: whiteColor,
                                        size: height * 0.03,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03500,
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Ts(text: 'Name', color: Colors.grey),
                        subtitle: Ts(text: "${controller.name}", size: 17),
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    actionsPadding: EdgeInsets.zero,
                                    contentPadding: EdgeInsets.zero,
                                    buttonPadding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    actionsAlignment: MainAxisAlignment.start,
                                    content: Container(
                                        width: width,
                                        height: height * 0.2,
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.08),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: height * 0.03,
                                                  ),
                                                  Ts(
                                                    text: "Enter your name",
                                                    size: 17,
                                                    weight: FontWeight.w500,
                                                  ),
                                                  TextFormField(
                                                    controller: _name,
                                                    decoration: InputDecoration(
                                                        border: UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: appColor
                                                                    .withOpacity(
                                                                        0.5)))),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.016,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.03),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: Ts(
                                                        text: "CANCEL",
                                                        color: Colors.grey,
                                                      )),
                                                  TextButton(
                                                      onPressed: () {
                                                        controller.updateName(
                                                            _name.text);
                                                        controller
                                                            .getUserData();
                                                        Get.back();
                                                      },
                                                      child: Ts(
                                                        text: "SAVE",
                                                        color: Colors.grey,
                                                      ))
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              color: appColor,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.175, right: width * 0.02),
                        child: Row(
                          children: [
                            Flexible(
                              child: Ts(
                                  text:
                                      'This is not your username or pin. This name will be visible to your WhatsApp contacts',
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02000,
                      ),
                      ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Ts(text: 'About', color: Colors.grey),
                        subtitle: Ts(text: "${controller.bio}", size: 17),
                        trailing: IconButton(
                            onPressed: () {
                              Get.to(() => About(),
                                  transition: Transition.rightToLeft);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: appColor,
                            )),
                      ),
                      SizedBox(
                        height: height * 0.02000,
                      ),
                      ListTile(
                        leading: Icon(Icons.call),
                        title: Ts(text: 'Phone', color: Colors.grey),
                        subtitle: Ts(text: "${controller.number}", size: 17),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
