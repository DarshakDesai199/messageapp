import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:messageapp/constant/app_notification.dart';
import 'package:messageapp/constant/call_%20function.dart';
import 'package:messageapp/constant/color.dart';
import 'package:messageapp/constant/common_container.dart';
import 'package:messageapp/constant/contact.dart';
import 'package:messageapp/constant/text.dart';
import 'package:messageapp/controller/user_info_controller.dart';
import 'package:messageapp/main.dart';
import 'package:messageapp/view/home/Home.dart';

import '../../../constant/media_widget.dart';
import '../../../controller/mobile_auth_controller.dart';
import '../popup/view_contact.dart';

class ChatRoom extends StatefulWidget {
  final String image, token, name, mobileNo, uid, chatroomId, bio, date;
  ChatRoom({
    Key? key,
    required this.image,
    required this.name,
    required this.mobileNo,
    required this.uid,
    required this.chatroomId,
    required this.bio,
    required this.date,
    required this.token,
  }) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  final TextEditingController _message = TextEditingController();
  FocusNode focusNode = FocusNode();
  AudioPlayer audioPlayer = AudioPlayer();
  File? userImage;
  final picker = ImagePicker();
  File? file;
  String? name;
  String? fileName;
  String? status;
  var audioTime;
  bool emojiShowing = false;
  bool mark = false;
  bool isRemove = false;
  bool isRemove1 = false;
  List clearList = [];
  List clearList1 = [];
  final InfoController _infoController = Get.put(InfoController());

  setStatus(String status) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(kFirebaseAuth.currentUser!.uid)
        .update({"status": status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");

      // setState(() {});
      // mark = false;
    }
    super.didChangeAppLifecycleState(state);
  }

  void initState() {
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
    focusNode.addListener(
      () {
        if (focusNode.hasFocus) {
          setState(() {
            emojiShowing = false;
          });
        }
      },
    );
    // getDeleteData();
    super.initState();
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  // void getDeleteData() async {
  //   final user = await FirebaseFirestore.instance
  //       .collection('chatRoom')
  //       .doc(widget.chatroomId)
  //       .get();
  //   Map<String, dynamic>? getUserData = user.data();
  //   setState(() {
  //     delete = getUserData!['status'];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isRemove1 == true
          ? AppBar(
              backgroundColor: appColor,
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () {
                    clear();
                    setState(() {
                      isRemove1 = false;
                    });
                  },
                  icon: Icon(Icons.arrow_back)),
              actions: [
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: width * 0.025),
                            title: Ts(
                                text: 'Delete message?',
                                weight: FontWeight.w400,
                                color: Colors.grey.shade600,
                                size: height * 0.02),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        getCURemove();
                                        setState(() {
                                          isRemove1 = false;
                                        });
                                        clearBoth();
                                        Get.back();
                                      },
                                      child: Ts(
                                          text: 'delete for me'.toUpperCase(),
                                          color: appColor,
                                          size: height * 0.017)),
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Ts(
                                          text: 'cancel'.toUpperCase(),
                                          color: appColor,
                                          size: height * 0.017)),
                                  TextButton(
                                      onPressed: () {
                                        getCURemove();
                                        getBURemove();
                                        setState(() {
                                          isRemove1 = false;
                                        });
                                        Get.back();
                                      },
                                      child: Ts(
                                          text: 'delete for everyone'
                                              .toUpperCase(),
                                          color: appColor,
                                          size: height * 0.017)),
                                  SizedBox(
                                    height: height * 0.02,
                                  )
                                ]),
                          );
                        },
                      );
                      // setState(() {
                      //   isRemove1 = false;
                      // });
                    },
                    icon: Icon(Icons.delete)),
                IconButton(
                    onPressed: () {},
                    splashRadius: height * 0.02,
                    icon: Icon(Icons.more_vert))
              ],
            )
          : AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: appColor,
              leading: IconButton(
                  onPressed: () {
                    // setState(() {
                    //   widget.isTap = false;
                    // });
                    Get.offAll(Home(), transition: Transition.leftToRight);
                  },
                  icon: Icon(Icons.arrow_back)),
              titleSpacing: -15,
              title: GestureDetector(
                onTap: () {
                  Get.to(ViewContact(
                      image: widget.image,
                      name: widget.name,
                      number: widget.mobileNo,
                      bio: widget.bio,
                      date: widget.date,
                      uid: widget.uid));
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: widget.image,
                          child: CircleAvatar(
                            radius: height * 0.025,
                            backgroundImage: NetworkImage(widget.image),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('user')
                              .doc(widget.uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<
                                      DocumentSnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.hasError) {
                              return Center(child: Ts(text: 'No Internet'));
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Ts(text: "Loading");
                            }
                            if (snapshot.hasData) {
                              status = snapshot.data!['status'];

                              return snapshot.data!['status'] == 'Online'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Ts(text: widget.name, size: 18),
                                        Ts(
                                            text: "${snapshot.data!['status']}",
                                            size: 12,
                                            color: Colors.white54),
                                      ],
                                    )
                                  : Ts(text: widget.name, size: 20);
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    splashRadius: height * 0.02,
                    icon: Icon(Icons.videocam)),
                GetBuilder<InfoController>(
                  builder: (controller) {
                    return IconButton(
                        onPressed: () async {
                          voiceCall(
                              name: widget.name,
                              image: widget.image,
                              number: widget.mobileNo,
                              uid: widget.uid,
                              cImg: controller.Img,
                              cName: controller.name,
                              cNumber: controller.number);
                        },
                        splashRadius: height * 0.02,
                        icon: Icon(Icons.call));
                  },
                ),
                PopupMenuButton(
                  splashRadius: height * 0.022,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: InkWell(
                        onTap: () {
                          Get.to(ViewContact(
                            name: widget.name,
                            image: widget.image,
                            number: widget.mobileNo,
                            bio: widget.bio,
                            date: widget.date,
                            uid: widget.uid,
                          ));
                        },
                        child: Ts(
                          text: 'View contact',
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Ts(
                                    text: 'Clear this chat?',
                                    weight: FontWeight.w500,
                                    color: Colors.black,
                                    size: height * 0.025),
                                content: Ts(
                                    text: 'Delete media received in this chat',
                                    color: Colors.grey),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Ts(
                                        text: 'cancel'.toUpperCase(),
                                        color: appColor,
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        clearAllMessage();
                                        Get.back();
                                      },
                                      child: Ts(
                                        text: 'clear chat'.toUpperCase(),
                                        color: appColor,
                                      ))
                                ],
                              );
                            },
                          );
                        },
                        child: Ts(
                          text: 'Clear chat',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
      backgroundColor: Color(0xfff8f8ff),
      body: WillPopScope(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chatRoom')
                    .doc(widget.chatroomId)
                    .collection(kFirebaseAuth.currentUser!.uid)
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    getMark();
                    getBothMark();
                    addUid();
                    addBothUid();
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var message = snapshot.data!.docs[index];
                        DateTime myDateTime = (message['time']).toDate();
                        var t = DateFormat.jm().format(myDateTime);
                        var isPlay = message['isPlay'];

                        return InkWell(
                          onLongPress: () {
                            setState(
                              () {
                                isRemove1 = true;
                              },
                            );
                            if (isRemove1 == true) {
                              /// current user
                              FirebaseFirestore.instance
                                  .collection('chatRoom')
                                  .doc(widget.chatroomId)
                                  .collection(kFirebaseAuth.currentUser!.uid)
                                  .doc(message.id)
                                  .update({'isRemove': true});

                              /// beside user
                              FirebaseFirestore.instance
                                  .collection('chatRoom')
                                  .doc(widget.chatroomId)
                                  .collection(widget.uid)
                                  .doc(message.id)
                                  .update({'isRemove': true});
                            } else {
                              return;
                            }
                          },
                          onTap: () {
                            setState(
                              () {
                                clearList.isEmpty ? isRemove1 = false : null;
                                clearList1.isEmpty ? isRemove1 = false : null;
                              },
                            );
                            isRemove = !isRemove;

                            /// current user

                            if (isRemove == true) {
                              if (isRemove1 == true) {
                                /// current user

                                FirebaseFirestore.instance
                                    .collection('chatRoom')
                                    .doc(widget.chatroomId)
                                    // .collection('chat')
                                    .collection(kFirebaseAuth.currentUser!.uid)
                                    .doc(message.id)
                                    .update({'isRemove': true});

                                /// beside user
                                FirebaseFirestore.instance
                                    .collection('chatRoom')
                                    .doc(widget.chatroomId)
                                    // .collection('chat')
                                    .collection(widget.uid)
                                    .doc(message.id)
                                    .update({'isRemove': true});
                              } else {
                                return;
                              }
                            } else {
                              /// current user
                              FirebaseFirestore.instance
                                  .collection('chatRoom')
                                  .doc(widget.chatroomId)
                                  .collection(kFirebaseAuth.currentUser!.uid)
                                  .doc(message.id)
                                  .update({'isRemove': false});

                              /// beside user
                              FirebaseFirestore.instance
                                  .collection('chatRoom')
                                  .doc(widget.chatroomId)
                                  .collection(widget.uid)
                                  .doc(message.id)
                                  .update({'isRemove': false});
                            }
                          },
                          child: CommonContainer(
                            uid: widget.uid,
                            message: message,
                            child: message['type'] == 'text'
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          message['message'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: height * 0.017,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: height * 0.018,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Ts(
                                                text: t,
                                                size: height * 0.0128,
                                                color: Colors.black54,
                                              ),
                                              SizedBox(
                                                width: width * 0.013,
                                              ),
                                              message['sendBy'] ==
                                                      kFirebaseAuth
                                                          .currentUser!.uid
                                                  ? message['isCheck'] == true
                                                      ? Icon(
                                                          Icons.done_all,
                                                          size: height * 0.02,
                                                          color: appColor,
                                                        )
                                                      : Icon(
                                                          Icons.check,
                                                          size: height * 0.018,
                                                          color: Colors.grey,
                                                        )
                                                  : SizedBox()
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                : message['type'] == 'img'
                                    ? message['message'] == ""
                                        ? Container(
                                            height: height * 0.35,
                                            width: width * 0.5,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 4),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      height * 0.01),
                                            ),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: const [
                                                Icon(Icons.clear,
                                                    color: Colors.white),
                                                CircularProgressIndicator(
                                                    color: Colors.white),
                                              ],
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              showBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    height: height,
                                                    width: width,
                                                    color: Colors.black,
                                                    child: Image.network(
                                                      message['message'],
                                                      // fit: BoxFit.fill,
                                                    ),
                                                  );
                                                },
                                              );
                                              // Get.to(ShowImageScreen(
                                              //     img: message['message']));
                                            },
                                            child: Container(
                                              height: height * 0.35,
                                              width: width * 0.5,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 4),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        height * 0.01),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        message['message']),
                                                    fit: BoxFit.cover),
                                              ),
                                              child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(2.5),
                                                    child: Container(
                                                      color: Colors.transparent
                                                          .withOpacity(0.1),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Ts(
                                                            text: t,
                                                            color: Colors.white,
                                                            size:
                                                                height * 0.015,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                width * 0.0080,
                                                          ),
                                                          message['sendBy'] ==
                                                                  kFirebaseAuth
                                                                      .currentUser!
                                                                      .uid
                                                              ? message['isCheck'] ==
                                                                      true
                                                                  ? Icon(
                                                                      Icons
                                                                          .done_all,
                                                                      size: height *
                                                                          0.02,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .check,
                                                                      size: height *
                                                                          0.018,
                                                                      color: Colors
                                                                          .grey,
                                                                    )
                                                              : SizedBox()
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          )
                                    : message['type'] == 'doc'
                                        ? GestureDetector(
                                            onTap: () {
                                              showBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return PDF().fromUrl(
                                                    message['message'],
                                                    placeholder: (double
                                                            progress) =>
                                                        Center(
                                                            child: Text(
                                                                '$progress %')),
                                                    errorWidget: (dynamic
                                                            error) =>
                                                        Center(
                                                            child: Text(error
                                                                .toString())),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: height * 0.09,
                                              width: width * 0.6,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          height * 0.02)),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 3),
                                                    child: Container(
                                                      height: height * 0.06,
                                                      width: width,
                                                      decoration: BoxDecoration(
                                                          color: appColor
                                                              .withOpacity(
                                                                  0.08),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      height *
                                                                          0.008)),
                                                      child: Row(children: [
                                                        SizedBox(
                                                          width: width * 0.015,
                                                        ),
                                                        Image.asset(
                                                          'assets/pdf.png',
                                                          height: height * 0.04,
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.015,
                                                        ),
                                                        Ts(
                                                            text: "${message['filename']}.doc"
                                                                .toLowerCase()),
                                                        Spacer(),
                                                        message['message'] == ''
                                                            ? SizedBox(
                                                                height: height *
                                                                    0.04,
                                                                child: Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  children: const [
                                                                    Icon(
                                                                        Icons
                                                                            .clear,
                                                                        color:
                                                                            appColor),
                                                                    CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          2,
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                        SizedBox(
                                                          width: width * 0.035,
                                                        ),
                                                      ]),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.005,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Ts(
                                                          text: t,
                                                          color: Colors
                                                              .grey.shade600,
                                                          size: height * 0.014,
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.0080,
                                                        ),
                                                        message['sendBy'] ==
                                                                kFirebaseAuth
                                                                    .currentUser!
                                                                    .uid
                                                            ? message['isCheck'] ==
                                                                    true
                                                                ? Icon(
                                                                    Icons
                                                                        .done_all,
                                                                    size:
                                                                        height *
                                                                            0.02,
                                                                    color:
                                                                        appColor,
                                                                  )
                                                                : Icon(
                                                                    Icons.check,
                                                                    size: height *
                                                                        0.018,
                                                                    color: Colors
                                                                        .grey,
                                                                  )
                                                            : SizedBox()
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            height: height * 0.085,
                                            width: width * 0.6,
                                            child: Row(children: [
                                              CircleAvatar(
                                                radius: height * 0.038,
                                                backgroundColor:
                                                    Color(0xffFF3D00)
                                                        .withOpacity(0.8),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Icon(
                                                        Icons.headset,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    // Ts(
                                                    //   text: "${audioTime}",
                                                    //   color: Colors.white,
                                                    // )
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      if (message['message'] ==
                                                          '')
                                                        SizedBox(
                                                          height: height * 0.04,
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: const [
                                                              Icon(Icons.clear,
                                                                  color:
                                                                      appColor),
                                                              CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      else
                                                        IconButton(
                                                          onPressed: () async {
                                                            audioPlayer
                                                                .onDurationChanged
                                                                .listen(
                                                                    (Duration
                                                                        d) {
                                                              print(
                                                                  'Max duration: $d');
                                                              setState(() {
                                                                d;
                                                                audioTime = d;
                                                              });
                                                            });
                                                            setState(() {
                                                              isPlay = !isPlay;
                                                            });
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'chatRoom')
                                                                .doc(widget
                                                                    .chatroomId)
                                                                .collection(
                                                                    kFirebaseAuth
                                                                        .currentUser!
                                                                        .uid)
                                                                .doc(message.id)
                                                                .update({
                                                              'isPlay': isPlay
                                                            });
                                                            if (isPlay ==
                                                                true) {
                                                              await audioPlayer
                                                                  .play(message[
                                                                      'message']);
                                                            } else {
                                                              await audioPlayer
                                                                  .pause();
                                                            }
                                                          },
                                                          icon: Icon(
                                                              isPlay == false
                                                                  ? Icons
                                                                      .play_arrow
                                                                  : Icons.pause,
                                                              color: Colors.grey
                                                                  .shade800,
                                                              size: height *
                                                                  0.045),
                                                        ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: width * 0.25,
                                                        height: height * 0.02,
                                                        child: Ts(
                                                            overFlow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            text:
                                                                "${message['filename']}.mp3"),
                                                      ),
                                                      Ts(
                                                        text: t,
                                                        color: Colors
                                                            .grey.shade600,
                                                        size: height * 0.014,
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.0080,
                                                      ),
                                                      message['sendBy'] ==
                                                              kFirebaseAuth
                                                                  .currentUser!
                                                                  .uid
                                                          ? message['isCheck'] ==
                                                                  true
                                                              ? Icon(
                                                                  Icons
                                                                      .done_all,
                                                                  size: height *
                                                                      0.02,
                                                                  color:
                                                                      appColor,
                                                                )
                                                              : Icon(
                                                                  Icons.check,
                                                                  size: height *
                                                                      0.018,
                                                                  color: Colors
                                                                      .grey,
                                                                )
                                                          : SizedBox()
                                                    ],
                                                  )
                                                ],
                                              )
                                            ]),
                                          ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                        child: Center(child: CircularProgressIndicator()));
                  }
                },
              ),
            ),

            /// send button
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02, vertical: height * 0.005),
              child: Row(
                children: [
                  Container(
                    height: height * 0.06,
                    width: width * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white),
                    child: SizedBox(
                      height: height * 0.06,
                      width: width * 0.82,
                      child: TextFormField(
                        focusNode: focusNode,
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: _message,
                        decoration: InputDecoration(
                            prefixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    emojiShowing = !emojiShowing;
                                    focusNode.unfocus();
                                    focusNode.canRequestFocus = true;
                                  });
                                },
                                splashRadius: 10,
                                icon: Icon(
                                  Icons.emoji_emotions_outlined,
                                  color: Colors.grey,
                                )),
                            suffixIcon: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return SizedBox(
                                              height: height * 0.38,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: width * 0.16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      height: height * 0.020,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        MediaWidget(
                                                            color: Color(
                                                                    0xff5E35B1)
                                                                .withOpacity(
                                                                    0.9),
                                                            onTap: () {
                                                              Get.back();
                                                              setDoc();
                                                            },
                                                            name: 'Document',
                                                            icon: Icons
                                                                .insert_drive_file),
                                                        MediaWidget(
                                                            color: Colors.pink,
                                                            onTap: () {
                                                              Get.back();
                                                              pickImage();
                                                            },
                                                            name: 'Camera',
                                                            icon: Icons
                                                                .photo_camera),
                                                        MediaWidget(
                                                            color: Color(
                                                                0xffAB47BC),
                                                            onTap: () {
                                                              Get.back();
                                                              setImage();
                                                            },
                                                            name: 'Gallery',
                                                            icon: Icons
                                                                .insert_photo),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        MediaWidget(
                                                            color: Color(
                                                                0xffE64A19),
                                                            onTap: () {
                                                              Get.back();
                                                              setAudio();
                                                            },
                                                            name: 'Audio',
                                                            icon:
                                                                Icons.headset),
                                                        MediaWidget(
                                                            color: Color(
                                                                0xff43A047),
                                                            onTap: () {
                                                              Get.back();
                                                            },
                                                            name: 'Location',
                                                            icon: Icons
                                                                .location_on),
                                                        MediaWidget(
                                                            color: Color(
                                                                0xff4DB6AC),
                                                            onTap: () {
                                                              Get.back();
                                                            },
                                                            name: 'Payment',
                                                            icon: Icons.paid),
                                                      ],
                                                    ),
                                                    MediaWidget(
                                                        color: Color(0xff01579B)
                                                            .withOpacity(0.8),
                                                        onTap: () {
                                                          Get.back();
                                                          Get.to(
                                                              GetContactList());
                                                        },
                                                        name: 'Contact',
                                                        icon: Icons.person),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      splashRadius: 10,
                                      icon: Transform.rotate(
                                          angle: 5.5,
                                          child: Icon(
                                            Icons.attach_file,
                                            color: Colors.grey,
                                          ))),
                                  _message.value.text.isEmpty
                                      ? GestureDetector(
                                          onTap: () {},
                                          child: CircleAvatar(
                                            radius: height * 0.015,
                                            backgroundColor: Colors.grey,
                                            child: Icon(
                                              Icons.currency_rupee,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  _message.value.text.isEmpty
                                      ? IconButton(
                                          onPressed: () {},
                                          splashRadius: 10,
                                          icon: Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey,
                                          ))
                                      : SizedBox()
                                ]),
                            hintText: "Message",
                            // hintTextDirection: TextDirection.ltr,
                            hintStyle: TextStyle(fontSize: 18),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  _message.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            onSendMessage();
                          },
                          child: CircleAvatar(
                            radius: height * 0.027,
                            child: Icon(Icons.send),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: height * 0.027,
                            child: Icon(Icons.keyboard_voice),
                          ),
                        )
                ],
              ),
            ),
            Offstage(
              offstage: !emojiShowing,
              child: SizedBox(
                height: height * 0.33,
                child: EmojiPicker(
                    onEmojiSelected: (Category category, Emoji emoji) {
                      _onEmojiSelected(emoji);
                    },
                    onBackspacePressed: _onBackspacePressed,
                    config: Config(
                        columns: 7,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        progressIndicatorColor: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        replaceEmojiOnLimitExceed: false,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL)),
              ),
            ),
            SizedBox(
              height: height * 0.007,
            )
          ],
        ),
        onWillPop: () {
          if (emojiShowing) {
            emojiShowing = true;
          } else {
            Get.back();
          }
          return Future.value(false);
        },
      ),
    );
  }

  /// message send tick function
  getMark() async {
    var info = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatroomId)
        .collection(widget.uid)
        .where('sendBy', isEqualTo: widget.uid)
        .where('isCheck', isEqualTo: false);
    var nnj = await info.get();
    for (var element in nnj.docs) {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatroomId)
          .collection(widget.uid)
          .doc(element.id)
          .update({"isCheck": true});
    }
  }

  getBothMark() async {
    var info = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatroomId)
        .collection(kFirebaseAuth.currentUser!.uid)
        .where('sendBy', isEqualTo: widget.uid)
        .where('isCheck', isEqualTo: false);
    var nnj = await info.get();
    for (var element in nnj.docs) {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatroomId)
          .collection(kFirebaseAuth.currentUser!.uid)
          .doc(element.id)
          .update({"isCheck": true});
    }
  }

  /// selected message clear on back button
  clear() async {
    var info = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatroomId)
        // .collection('chat')
        .collection(kFirebaseAuth.currentUser!.uid)
        .where('isRemove', isEqualTo: true);

    var sdf = await info.get();

    for (var element in sdf.docs) {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatroomId)
          // .collection('chat')
          .collection(kFirebaseAuth.currentUser!.uid)
          .doc(element.id)
          .update({'isRemove': false});
    }
  }

  clearBoth() async {
    var info = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatroomId)
        // .collection('chat')
        .collection(widget.uid)
        .where('isRemove', isEqualTo: true);

    var sdf = await info.get();

    for (var element in sdf.docs) {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatroomId)
          // .collection('chat')
          .collection(widget.uid)
          .doc(element.id)
          .update({'isRemove': false});
    }
  }

  /// id add in List
  addUid() async {
    var info = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatroomId)
        // .collection('chat')
        .collection(kFirebaseAuth.currentUser!.uid)
        .where('isRemove', isEqualTo: true);

    var sdf = await info.get();
    clearList = [];

    for (var element in sdf.docs) {
      clearList.add(element.id);
    }
  }

  addBothUid() async {
    addUid();
    var info1 = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatroomId)
        .collection(widget.uid)
        .where('isRemove', isEqualTo: true);

    var sdf1 = await info1.get();
    clearList1 = [];

    for (var element in sdf1.docs) {
      clearList1.add(element.id);
    }
  }

  ///Delete current user message function
  getCURemove() async {
    var info = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatroomId)
        // .collection('chat')
        .collection(kFirebaseAuth.currentUser!.uid)
        .where('isRemove', isEqualTo: true);

    var sdf = await info.get();

    for (var element in sdf.docs) {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatroomId)
          // .collection('chat')
          .collection(kFirebaseAuth.currentUser!.uid)
          .doc(element.id)
          .delete();
    }
  }

  /// Delete beside user message function
  getBURemove() async {
    var info = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatroomId)
        // .collection('chat')
        .collection(widget.uid)
        .where('isRemove', isEqualTo: true);

    var sdf = await info.get();

    for (var element in sdf.docs) {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatroomId)
          // .collection('chat')
          .collection(widget.uid)
          .doc(element.id)
          .delete();
    }
  }

  /// delete all message
  clearAllMessage() async {
    var info = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatroomId)
        .collection(kFirebaseAuth.currentUser!.uid);

    var sdf = await info.get();

    for (var element in sdf.docs) {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatroomId)
          .collection(kFirebaseAuth.currentUser!.uid)
          .doc(element.id)
          .delete();
    }
  }

  _onEmojiSelected(Emoji emoji) {
    _message
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _message.text.length));
  }

  _onBackspacePressed() {
    _message
      ..text = _message.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _message.text.length));
  }

  /// send message
  Future onSendMessage() async {
    var x = '${Random().nextInt(100000)}';
    if (_message.text.isNotEmpty) {
      AppNotificationHandler.sendMessage(
          msg: _message.text, receiverFcmToken: widget.token);
      Map<String, dynamic> messages = {
        'sendBy': kFirebaseAuth.currentUser!.uid,
        'message': _message.text,
        'type': 'text',
        'isPlay': false,
        'filename': fileName,
        'time': DateTime.now(),
        // 'token': storage.read('token'),
        'isCheck': mark,
        'isRemove': false
      };
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatroomId)
          .collection(kFirebaseAuth.currentUser!.uid)
          .doc(x)
          .set(messages);
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatroomId)
          .collection(widget.uid)
          .doc(x)
          .set(messages);

      _message.clear();

      /// user show when message to another
      FirebaseFirestore.instance
          .collection('user')
          .doc(kFirebaseAuth.currentUser!.uid)
          .collection('roomId')
          .doc(widget.chatroomId)
          .set({'isCheck': mark, 'time': DateTime.now()});
      FirebaseFirestore.instance
          .collection('user')
          .doc(widget.uid)
          .collection('roomId')
          .doc(widget.chatroomId)
          .set({'isCheck': mark, 'time': DateTime.now()});
    } else {
      print('some text add');
    }
  }

  /// send image
  setImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      File doc = File(result.files.single.path.toString());

      setState(() {
        file = doc;
      });
      name = result.names.first.toString();

      uploadImage(widget.chatroomId, file, fileName, widget.uid);
    } else {
      return null;
    }
  }

  /// pick image camera
  pickImage() async {
    var filePick = await picker.pickImage(source: ImageSource.camera);
    if (filePick != null) {
      setState(() {
        userImage = File(filePick.path);
      });
      uploadImage(widget.chatroomId, userImage, fileName, widget.uid);
    } else {
      return null;
    }
  }

  Future uploadImage(chatRoomId, file, fileName, uid) async {
    fileName = 'IMAGE${Random().nextInt(100000)}';
    int status = 1;
    Map<String, dynamic> messages = {
      'sendBy': kFirebaseAuth.currentUser!.uid,
      'message': '',
      'type': 'img',
      'filename': fileName,
      'isPlay': false,
      'isRemove': false,
      'isCheck': false,
      'token': storage.read('fcm'),
      'time': DateTime.now()
    };

    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection(kFirebaseAuth.currentUser!.uid)
        .doc(fileName)
        .set(messages);
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection(uid)
        .doc(fileName)
        .set(messages);
    var ref =
        FirebaseStorage.instance.ref().child('image').child('$fileName.img');
    var uploadTask = await ref.putFile(file!).catchError((error) async {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection(kFirebaseAuth.currentUser!.uid)
          .doc(fileName)
          .delete();
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection(uid)
          .doc(fileName)
          .delete();
      status = 0;
    });
    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection(kFirebaseAuth.currentUser!.uid)
          .doc(fileName)
          .update({'message': imageUrl});
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection(uid)
          .doc(fileName)
          .update({'message': imageUrl});
      print(
          '================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>$imageUrl');
    }
  }

  /// send Document
  setDoc() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc']);
    if (result != null) {
      File doc = File(result.files.single.path.toString());

      setState(() {
        file = doc;
      });
      name = result.names.first.toString();

      uploadDoc(widget.chatroomId, file, fileName, widget.uid);
    } else {
      return null;
    }
  }

  Future uploadDoc(chatRoomId, file, fileName, uid) async {
    fileName = 'DOC${Random().nextInt(100000)}';
    int status = 1;
    Map<String, dynamic> mess = {
      'sendBy': kFirebaseAuth.currentUser!.uid,
      'message': '',
      'type': 'doc',
      'isPlay': false,
      'isRemove': false,
      'isCheck': false,
      'token': storage.read('fcm'),
      'filename': fileName,
      'time': DateTime.now()
    };

    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection(kFirebaseAuth.currentUser!.uid)
        .doc(fileName)
        .set(mess);
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection(uid)
        .doc(fileName)
        .set(mess);
    var ref =
        FirebaseStorage.instance.ref().child('doc').child('$fileName.doc');
    var uploadTask = await ref.putFile(file!).catchError((error) async {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection(kFirebaseAuth.currentUser!.uid)
          .doc(fileName)
          .delete();
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection(uid)
          .doc(fileName)
          .delete();
      status = 0;
    });
    if (status == 1) {
      String docUrl = await uploadTask.ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection(kFirebaseAuth.currentUser!.uid)
          .doc(fileName)
          .update({'message': docUrl});
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection(uid)
          .doc(fileName)
          .update({'message': docUrl});
      print(
          '================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>$docUrl');
    }
  }

  /// send Audio
  setAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      File doc = File(result.files.single.path.toString());

      setState(() {
        file = doc;
      });
      name = result.names.first.toString();

      uploadAudio(widget.chatroomId, file, fileName, widget.uid);
    } else {
      return null;
    }
  }

  Future uploadAudio(chatRoomId, file, fileName, uid) async {
    fileName = 'AUD-${Random().nextInt(100000)}';
    int status = 1;
    Map<String, dynamic> mess = {
      'sendBy': kFirebaseAuth.currentUser!.uid,
      'message': '',
      'type': 'mp3',
      'isPlay': false,
      'isRemove': false,
      'isCheck': false,
      'token': storage.read('fcm'),
      'filename': fileName,
      'time': DateTime.now()
    };
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection(kFirebaseAuth.currentUser!.uid)
        .doc(fileName)
        .set(mess);
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection(uid)
        .doc(fileName)
        .set(mess);
    var ref =
        FirebaseStorage.instance.ref().child('doc').child('$fileName.doc');
    var uploadTask = await ref.putFile(file!).catchError((error) async {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection(kFirebaseAuth.currentUser!.uid)
          .doc(fileName)
          .delete();
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection(uid)
          .doc(fileName)
          .delete();
      status = 0;
    });
    if (status == 1) {
      String mp3Url = await uploadTask.ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection(kFirebaseAuth.currentUser!.uid)
          .doc(fileName)
          .update({'message': mp3Url});
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection(uid)
          .doc(fileName)
          .update({'message': mp3Url});
      print(
          '================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>$mp3Url');
    }
  }
}
