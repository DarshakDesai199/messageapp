import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messageapp/constant/color.dart';
import 'package:messageapp/controller/mobile_auth_controller.dart';
import 'package:messageapp/controller/user_info_controller.dart';
import 'package:messageapp/view/home/Home.dart';

import '../../../controller/status_controller.dart';

class StatusAdd extends StatefulWidget {
  final status;
  const StatusAdd({
    Key? key,
    this.status,
  }) : super(key: key);

  @override
  State<StatusAdd> createState() => _StatusAddState();
}

class _StatusAddState extends State<StatusAdd> {
  TextEditingController statusMessage = TextEditingController();
  StatusController statusController = Get.put(StatusController());
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.file(
              widget.status,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.015),
            child: Row(
              children: [
                Container(
                  height: height * 0.06,
                  width: width * 0.82,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white),
                  child: SizedBox(
                    height: height * 0.06,
                    width: width * 0.82,
                    child: TextFormField(
                      controller: statusMessage,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                            onPressed: () {},
                            splashRadius: 10,
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.grey,
                            )),
                        hintText: "Message",
                        hintTextDirection: TextDirection.ltr,
                        hintStyle: TextStyle(fontSize: 18),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                Obx(
                  () => statusController.isLoading.value == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : GetBuilder<InfoController>(
                          builder: (controller) {
                            return GestureDetector(
                              onTap: () {
                                statusController.isLoaded();
                                if (statusController.isLoading.value == true) {
                                  uploadStatus(controller.name).then(
                                    (value) {
                                      print('Status upload');
                                      // Future.delayed(
                                      //   Duration(minutes: 4),
                                      //   () async {
                                      //     var x = FirebaseFirestore.instance
                                      //         .collection('status')
                                      //         .doc(kFirebaseAuth
                                      //             .currentUser!.uid)
                                      //         .collection('data')
                                      //         .where('endTime',
                                      //             isLessThanOrEqualTo:
                                      //                 DateTime.now());
                                      //     var y = await x.get();
                                      //     y.docs.forEach(
                                      //       (element) {
                                      //         print('hii');
                                      //         FirebaseFirestore.instance
                                      //             .collection('status')
                                      //             .doc(kFirebaseAuth
                                      //                 .currentUser!.uid)
                                      //             .collection('data')
                                      //             .doc(element.id)
                                      //             .delete();
                                      //         FirebaseFirestore.instance
                                      //             .collection('status')
                                      //             .doc(kFirebaseAuth
                                      //                 .currentUser!.uid)
                                      //             .delete();
                                      //       },
                                      //     );
                                      //   },
                                      // );
                                    },
                                  );
                                } else {
                                  statusController.isNotLoaded();
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: appColor,
                                radius: height * 0.027,
                                child: Icon(
                                  Icons.send,
                                  color: whiteColor,
                                ),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<String?> uploadFile({File? file, String? filename}) async {
    print("File path:${file!.path}");
    try {
      var response = await firebase_storage.FirebaseStorage.instance
          .ref("product_image/$filename")
          .putFile(file);
      String url = await response.storage
          .ref("product_image/$filename")
          .getDownloadURL();
      print('IMAHGE URL $url');
      return url;
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }
  }

  Future uploadStatus(name) async {
    String? url = await uploadFile(
        file: widget.status, filename: '${Random().nextInt(12345689)}');
    FirebaseFirestore.instance
        .collection('status')
        .doc(kFirebaseAuth.currentUser!.uid)
        .set({'image': url});
    FirebaseFirestore.instance
        .collection('status')
        .doc(kFirebaseAuth.currentUser!.uid)
        .collection('data')
        .doc()
        .set(
      {
        'image': url,
        'StatusMessage': statusMessage.text,
        'time': DateTime.now(),
        'endTime': DateTime.now().add(Duration(minutes: 1)),
        'name': name
      },
    ).catchError((e) {
      statusController.isNotLoaded();
    });
    Get.offAll(() => Home(), transition: Transition.leftToRight);
    statusController.isNotLoaded();
  }
}
