import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:messageapp/constant/image_loading.dart';
import 'package:messageapp/constant/text.dart';
import 'package:messageapp/controller/mobile_auth_controller.dart';
import 'package:messageapp/controller/user_info_controller.dart';
import 'package:messageapp/main.dart';
import 'package:messageapp/view/home/status/status_add.dart';
import 'package:messageapp/view/home/status/status_view_screen.dart';
import 'package:status_view/status_view.dart';

import '../../../constant/color.dart';

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> with WidgetsBindingObserver {
  bool isShow = false;
  File? userImage;
  String? id;
  final picker = ImagePicker();

  pickImage() async {
    var filePick = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      userImage = File(filePick!.path);
      Get.to(
          () => StatusAdd(
                status: userImage,
              ),
          transition: Transition.leftToRight);
    });
  }

  InfoController infoController = Get.put(InfoController());

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    } else {
      print('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb');
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('++++++++++${DateTime.now().subtract(Duration(days: 1))}');
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: height * 0.02),
          InkWell(
            onTap: () {
              pickImage();
            },
            child: Row(
              children: [
                GetBuilder<InfoController>(
                  builder: (controller) => Stack(
                    alignment: Alignment.bottomRight,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: height * 0.07,
                        width: height * 0.07,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: ImageLoading(
                              hight: height * 0.07,
                              width: height * 0.07,
                              url: '${controller.Img}'),
                        ),
                      ),
                      Positioned(
                        bottom: -height * 0.002,
                        right: -width * 0.005,
                        child: Container(
                          alignment: Alignment.center,
                          height: height * 0.032,
                          width: height * 0.032,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appColor,
                              border:
                                  Border.all(color: Colors.white, width: 2)),
                          child: Center(
                              child: Icon(
                            Icons.add,
                            color: whiteColor,
                            size: 18,
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: width * 0.02500,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Ts(
                      text: "My Status",
                      size: height * 0.022,
                      weight: FontWeight.w500,
                    ),
                    SizedBox(height: height * 0.0025),
                    Ts(
                      text: "Tap to add status update",
                      color: Colors.grey,
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: height * 0.02),
          Ts(
            text: "Recent updates",
            weight: FontWeight.w500,
            color: Colors.grey,
          ),
          SizedBox(height: height * 0.02),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('status').snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var userStatus = snapshot.data!.docs;
                      return kFirebaseAuth.currentUser!.uid ==
                              userStatus[index].id
                          ? SizedBox()
                          : StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(kFirebaseAuth.currentUser!.uid)
                                  .collection('roomId')
                                  // .orderBy('time', descending: false)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, i) {
                                      id = snapshot.data!.docs[i].id;

                                      return kFirebaseAuth.currentUser!.uid +
                                                      userStatus[index].id ==
                                                  id ||
                                              userStatus[index].id +
                                                      kFirebaseAuth
                                                          .currentUser!.uid ==
                                                  id
                                          ? StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('status')
                                                  .doc(userStatus[index].id)
                                                  .collection('data')
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<
                                                          QuerySnapshot<
                                                              Map<String,
                                                                  dynamic>>>
                                                      snapshot) {
                                                if (snapshot.hasError) {
                                                  return Ts(text: 'No Status');
                                                }
                                                if (snapshot.hasData) {
                                                  var io = snapshot.data!.docs;
                                                  var date =
                                                      io[0]['time'] ?? "";
                                                  DateTime myDateTime =
                                                      (date).toDate();
                                                  var t = DateFormat.jm()
                                                      .format(myDateTime);
                                                  return InkWell(
                                                    onTap: () async {
                                                      Get.to(StoriesView(
                                                        uid: userStatus[index]
                                                            .id,
                                                      ));
                                                    },
                                                    child: Container(
                                                      height: height * 0.09,
                                                      width: width,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  width * 0.04),
                                                      child: Row(
                                                        children: [
                                                          StatusView(
                                                            radius:
                                                                height * 0.033,
                                                            spacing: 15,
                                                            strokeWidth: 2,
                                                            indexOfSeenStatus:
                                                                2,
                                                            numberOfStatus:
                                                                io.length,
                                                            padding: 4,
                                                            centerImageUrl:
                                                                "${io[0]['image'] ?? ""}",
                                                            seenColor: appColor,
                                                            unSeenColor:
                                                                Colors.grey,
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.04,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Ts(
                                                                text:
                                                                    '${io[0]['name'] ?? ''}',
                                                                size: height *
                                                                    0.02,
                                                                weight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              SizedBox(
                                                                height: height *
                                                                    0.005,
                                                              ),
                                                              Ts(
                                                                text: t,
                                                                size: height *
                                                                    0.017,
                                                                color:
                                                                    Colors.grey,
                                                                weight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              },
                                            )
                                          : SizedBox();
                                    },
                                  );
                                } else {
                                  return Center(child: SizedBox());
                                }
                              },
                            );
                    },
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          )
        ]),
      ),
    );
  }
}
