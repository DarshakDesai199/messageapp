import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:messageapp/constant/color.dart';
import 'package:messageapp/constant/convertDate.dart';
import 'package:messageapp/constant/text.dart';

import '../../../controller/mobile_auth_controller.dart';
import '../../../main.dart';
import 'chatroom.dart';

class Chats extends StatefulWidget {
  final String searchText;
  const Chats({
    Key? key,
    required this.searchText,
  }) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  String? roomId;

  /// chat functionality
  Future<String> chatRoomId(String user1, String user2) async {
    if (user1[0].toLowerCase().codeUnitAt(0) >
        user2.toLowerCase().codeUnitAt(0)) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  getPendingMessage(String roomId, String id) async {
    var ino = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(roomId)
        .collection(id)
        .where('isCheck', isEqualTo: false);
    var fg = await ino.get();
    fg.docs.forEach((element) {
      print('${fg.docs.length}');
    });
  }

  String? id;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user")
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> products = snapshot.data!.docs;
            // log("token1======>${products.length}");
            if (widget.searchText.isNotEmpty) {
              products = products.where((element) {
                return element
                    .get('name')
                    .toString()
                    .toLowerCase()
                    .contains(widget.searchText.toLowerCase());
              }).toList();
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                var x = kFirebaseAuth.currentUser!.uid[0]
                            .toLowerCase()
                            .codeUnitAt(0) >
                        data.id.toLowerCase().codeUnitAt(0)
                    ? kFirebaseAuth.currentUser!.uid + data.id
                    : data.id + kFirebaseAuth.currentUser!.uid;
                return kFirebaseAuth.currentUser!.uid == data.id
                    ? SizedBox()
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('user')
                            .doc(kFirebaseAuth.currentUser!.uid)
                            .collection('roomId')
                            .orderBy('time', descending: false)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, i) {
                                id = snapshot.data!.docs[i].id;
                                var k = snapshot.data!.docs[i]['time'];
                                DateTime myDateTime = (k).toDate();
                                var d = DateFormat.d().format(myDateTime);
                                var m = DateFormat.MMMM().format(myDateTime);
                                var y = DateFormat.y().format(myDateTime);
                                var dt = '$d $m $y';
                                getPendingMessage(x, data.id);
                                return kFirebaseAuth.currentUser!.uid +
                                                products[index].id ==
                                            id ||
                                        products[index].id +
                                                kFirebaseAuth
                                                    .currentUser!.uid ==
                                            id
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: height * 0.016,
                                          horizontal: width * 0.03,
                                        ),
                                        child: GestureDetector(
                                          onTap: () async {
                                            roomId = await chatRoomId(
                                                kFirebaseAuth.currentUser!.uid,
                                                products[index].id);
                                            print('ROOMID:-$roomId}');
                                            Get.to(
                                                () => ChatRoom(
                                                      chatroomId: '$roomId',
                                                      uid: products[index].id,
                                                      token: products[index]
                                                          ['token'],
                                                      image: products[index]
                                                          ['image'],
                                                      mobileNo: products[index]
                                                          ['mobile'],
                                                      name: products[index]
                                                          ['name'],
                                                      bio: products[index]
                                                          ['bio'],
                                                      date: dt,
                                                    ),
                                                transition:
                                                    Transition.rightToLeft);
                                          },
                                          child: Container(
                                            height: height * 0.065,
                                            width: width,
                                            color: Colors.transparent,
                                            child: Row(children: [
                                              Expanded(
                                                flex: 1,
                                                child: CircleAvatar(
                                                  radius: height * 0.034,
                                                  backgroundColor: Colors.grey,
                                                  backgroundImage: NetworkImage(
                                                      "${products[index]['image']}"),
                                                ),
                                              ),
                                              SizedBox(width: width * 0.04),
                                              Expanded(
                                                  flex: 5,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Ts(
                                                            text:
                                                                "${products[index]['name']}",
                                                            color: Colors.black,
                                                            size: 18,
                                                          ),
                                                          StreamBuilder(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "chatRoom")
                                                                .doc(x)
                                                                .collection(
                                                                    kFirebaseAuth
                                                                        .currentUser!
                                                                        .uid)
                                                                .orderBy('time',
                                                                    descending:
                                                                        true)
                                                                .snapshots(),
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        QuerySnapshot<
                                                                            Map<String,
                                                                                dynamic>>>
                                                                    snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                return SizedBox(
                                                                  height:
                                                                      height *
                                                                          0.023,
                                                                  width: width *
                                                                      0.16,
                                                                  child: ListView
                                                                      .builder(
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    itemCount: snapshot
                                                                        .data!
                                                                        .docs
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            i) {
                                                                      var lastTime = snapshot
                                                                          .data!
                                                                          .docs[i]['time'];
                                                                      DateTime
                                                                          myDateTime =
                                                                          (lastTime)
                                                                              .toDate();
                                                                      var t = DateFormat
                                                                              .jm()
                                                                          .format(
                                                                              myDateTime);
                                                                      return Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(bottom: 8.0),
                                                                        child: MsgDate(
                                                                            date:
                                                                                myDateTime),
                                                                      );
                                                                    },
                                                                  ),
                                                                );
                                                              } else {
                                                                return Text(
                                                                    "Available");
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          StreamBuilder(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "chatRoom")
                                                                .doc(x)
                                                                .collection(
                                                                    kFirebaseAuth
                                                                        .currentUser!
                                                                        .uid)
                                                                .orderBy('time',
                                                                    descending:
                                                                        true)
                                                                .snapshots(),
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        QuerySnapshot<
                                                                            Map<String,
                                                                                dynamic>>>
                                                                    snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                return SizedBox(
                                                                  height:
                                                                      height *
                                                                          0.024,
                                                                  width: width *
                                                                      0.4,
                                                                  child: ListView
                                                                      .builder(
                                                                    itemCount: snapshot
                                                                        .data!
                                                                        .docs
                                                                        .length,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    itemBuilder:
                                                                        (context,
                                                                            i) {
                                                                      var info = snapshot
                                                                          .data!
                                                                          .docs[i];
                                                                      var lastMess = snapshot
                                                                          .data!
                                                                          .docs[i]['message'];
                                                                      var filename = snapshot
                                                                          .data!
                                                                          .docs[i]['filename'];

                                                                      return Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(bottom: 8.0),
                                                                        child: info['type'] ==
                                                                                'img'
                                                                            ? Row(
                                                                                children: [
                                                                                  Icon(Icons.photo, color: Colors.grey, size: height * 0.022),
                                                                                  SizedBox(
                                                                                    width: width * 0.015,
                                                                                  ),
                                                                                  Ts(
                                                                                    text: 'Photo',
                                                                                    color: Colors.grey,
                                                                                    size: 15,
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            : Row(
                                                                                children: [
                                                                                  info['type'] == 'text'
                                                                                      ? SizedBox()
                                                                                      : Padding(
                                                                                          padding: EdgeInsets.only(right: width * 0.015),
                                                                                          child: Icon(Icons.article, color: Colors.grey, size: height * 0.022),
                                                                                        ),
                                                                                  Ts(
                                                                                    text: info['type'] == 'text' ? lastMess : filename,
                                                                                    color: Colors.grey,
                                                                                    size: 15,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                      );
                                                                    },
                                                                  ),
                                                                );
                                                              } else {
                                                                return Text(
                                                                    "Available");
                                                              }
                                                            },
                                                          ),
                                                          StreamBuilder(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'chatRoom')
                                                                .doc(x)
                                                                .collection(
                                                                    data.id)
                                                                .where('sendBy',
                                                                    isEqualTo:
                                                                        data.id)
                                                                .where(
                                                                    'isCheck',
                                                                    isEqualTo:
                                                                        false)
                                                                .snapshots(),
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        QuerySnapshot<
                                                                            Map<String,
                                                                                dynamic>>>
                                                                    snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                var length =
                                                                    snapshot
                                                                        .data!
                                                                        .docs
                                                                        .length;
                                                                print(
                                                                    '${snapshot.data!.docs.length}');

                                                                return length ==
                                                                        0
                                                                    ? SizedBox()
                                                                    : Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: width * 0.08),
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              height * 0.012,
                                                                          backgroundColor:
                                                                              appColor,
                                                                          child:
                                                                              Center(
                                                                            child: Ts(
                                                                                text: length.toString(),
                                                                                size: height * 0.016,
                                                                                color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      );
                                                              } else {
                                                                return SizedBox();
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ))
                                            ]),
                                          ),
                                        ),
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
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: appColor,
              ),
            );
          }
        },
      ),
    );
  }
}
