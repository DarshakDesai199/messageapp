import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:messageapp/constant/color.dart';
import 'package:messageapp/constant/text.dart';
import 'package:messageapp/main.dart';

import '../../../controller/mobile_auth_controller.dart';
import 'chatroom.dart';

class AllUser extends StatefulWidget {
  const AllUser({Key? key}) : super(key: key);

  @override
  State<AllUser> createState() => _AllUserState();
}

class _AllUserState extends State<AllUser> {
  bool openSearch = false;
  String searchTexts = "";
  String? roomId;

  Future<String> chatRoomId(String user1, String user2) async {
    if (user1[0].toLowerCase().codeUnitAt(0) >
        user2.toLowerCase().codeUnitAt(0)) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  final TextEditingController _search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Container(height: height * 0.01, width: width, color: appColor),
          Container(
            height: height * 0.06,
            width: width,
            color: appColor,
            child: openSearch == false
                ? Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: whiteColor,
                          )),
                      SizedBox(
                        width: width * 0.06,
                      ),
                      Ts(
                        text: "Select contact",
                        weight: FontWeight.w500,
                        size: height * 0.024,
                        color: whiteColor,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            openSearch = true;
                          });
                        },
                        icon: Icon(Icons.search, color: whiteColor),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ))
                    ],
                  )
                : AnimatedContainer(
                    color: Colors.white,
                    height: height * 0.2,
                    width: width,
                    curve: Curves.bounceInOut,
                    duration: Duration(seconds: 5),
                    child: Column(children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  openSearch = false;
                                });
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              )),
                          Expanded(
                            child: TextFormField(
                              controller: _search,
                              onChanged: (value) {
                                setState(() {
                                  searchTexts = value;
                                });
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: width * 0.02),
                                  hintText: "Search....",
                                  hintStyle:
                                      TextStyle(fontSize: height * 0.022),
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          )
                        ],
                      )
                    ]),
                  ),
          ),
          Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("user")
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> products = snapshot.data!.docs;
                    log("token1======>${products.length}");
                    if (searchTexts.isNotEmpty) {
                      products = products.where((element) {
                        return element
                            .get('name')
                            .toString()
                            .toLowerCase()
                            .contains(searchTexts.toLowerCase());
                      }).toList();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        var id = snapshot.data!.docs[index].id;
                        var k = snapshot.data!.docs[index]['time'];
                        DateTime myDateTime = (k).toDate();
                        var d = DateFormat.d().format(myDateTime);
                        var m = DateFormat.MMMM().format(myDateTime);
                        var y = DateFormat.y().format(myDateTime);
                        var dt = '$d $m $y';
                        return kFirebaseAuth.currentUser!.uid !=
                                products[index].id
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
                                    print('RoomId >> $roomId');

                                    Get.to(
                                        () => ChatRoom(
                                              token: products[index]['token'],
                                              chatroomId: "$roomId",
                                              uid: products[index].id,
                                              image: products[index]['image'],
                                              mobileNo: products[index]
                                                  ['mobile'],
                                              name: products[index]['name'],
                                              bio: products[index]['bio'],
                                              date: dt,
                                            ),
                                        transition: Transition.leftToRight);
                                  },
                                  child: Container(
                                    height: height * 0.07,
                                    width: width,
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: height * 0.034,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(
                                              "${products[index]['image']}"),
                                        ),
                                        SizedBox(
                                          width: width * 0.05,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Ts(
                                              text:
                                                  "${products[index]['name']}",
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              height: height * 0.005,
                                            ),
                                            Ts(
                                              text: "${products[index]['bio']}",
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                            // StreamBuilder(
                                            //   stream: FirebaseFirestore.instance
                                            //       .collection("chatRoom")
                                            //       .doc()
                                            //       .collection('chat')
                                            //       .orderBy('time',
                                            //           descending: true)
                                            //       .snapshots(),
                                            //   builder: (BuildContext context,
                                            //       AsyncSnapshot<
                                            //               QuerySnapshot<
                                            //                   Map<String,
                                            //                       dynamic>>>
                                            //           snapshot) {
                                            //     if (snapshot.hasData) {
                                            //       print(
                                            //           '>>>>>>>>>>> ${roomId}');
                                            //       return SizedBox(
                                            //         height: 15,
                                            //         width: width * 0.5,
                                            //         child: ListView.builder(
                                            //           itemCount: snapshot
                                            //               .data!.docs.length,
                                            //           itemBuilder:
                                            //               (context, index) {
                                            //             var lastMess = snapshot
                                            //                     .data!
                                            //                     .docs[index]
                                            //                 ['message'];
                                            //             print(
                                            //                 '>>>>>>>>>>> $lastMess');
                                            //             return Ts(
                                            //               text: lastMess,
                                            //               color: Colors.grey,
                                            //               size: 15,
                                            //             );
                                            //           },
                                            //         ),
                                            //       );
                                            //     } else {
                                            //       return Text("Available");
                                            //     }
                                            //   },
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox();
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            ],
          )
        ]),
      ),
    );
  }
}
