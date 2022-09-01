import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:messageapp/constant/call_%20function.dart';
import 'package:messageapp/constant/color.dart';
import 'package:messageapp/controller/mobile_auth_controller.dart';
import 'package:messageapp/controller/user_info_controller.dart';

import '../../constant/Text.dart';
import '../../main.dart';

class Calls extends StatefulWidget {
  const Calls({Key? key}) : super(key: key);

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('calls')
            .doc(kFirebaseAuth.currentUser!.uid)
            .collection('data')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                DateTime myDateTime = (data['time']).toDate();
                var time = DateFormat.jm().format(myDateTime);
                var month = DateFormat.MMM().format(myDateTime);
                var date = DateFormat.d().format(myDateTime);
                var formatTime = '$date $month, $time';
                // print('///$formatTime');
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.016, horizontal: width * 0.04),
                  child: Container(
                    height: height * 0.065,
                    width: width,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: height * 0.034,
                          // backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage("${data['image']}"),
                        ),
                        SizedBox(
                          width: width * 0.05,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Ts(
                              text: '${data['name']}',
                              color: Colors.black,
                              size: 18,
                            ),
                            SizedBox(
                              height: height * 0.005,
                            ),
                            Row(
                              children: [
                                data['type'] == 'dial'
                                    ? Icon(Icons.call_made,
                                        color: Colors.green,
                                        size: height * 0.02)
                                    : Icon(Icons.call_received,
                                        color: Colors.red, size: height * 0.02),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Ts(
                                  text: formatTime,
                                  color: Colors.grey.shade600,
                                  size: 15,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        data['call'] == 'voice'
                            ? GetBuilder<InfoController>(
                                builder: (controller) {
                                  return IconButton(
                                      onPressed: () async {
                                        voiceCall(
                                            name: data['name'],
                                            image: data['image'],
                                            number: data['number'],
                                            uid: data['uid'],
                                            cImg: controller.Img,
                                            cNumber: controller.number,
                                            cName: controller.name);
                                      },
                                      splashRadius: height * 0.02,
                                      icon: Icon(
                                        Icons.call,
                                        color: appColor,
                                        size: height * 0.035,
                                      ));
                                },
                              )
                            : IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.videocam,
                                  color: appColor,
                                  size: height * 0.035,
                                )),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: appColor,
            ));
          }
        },
      ),
    );
  }
}
