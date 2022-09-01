import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:messageapp/constant/call_%20function.dart';
import 'package:messageapp/constant/text.dart';
import 'package:messageapp/constant/viewContact_widget.dart';
import 'package:messageapp/controller/user_info_controller.dart';
import 'package:messageapp/main.dart';

class ViewContact extends StatefulWidget {
  final String image, name, number, bio, date, uid;

  const ViewContact({
    super.key,
    required this.image,
    required this.name,
    required this.number,
    required this.bio,
    required this.date,
    required this.uid,
    // required this.date
  });

  @override
  State<ViewContact> createState() => _ViewContactState();
}

class _ViewContactState extends State<ViewContact> {
  @override
  Widget build(BuildContext context) {
    // var k = widget.date;
    // print(k.runtimeType);
    // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(k);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: width,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back)),
                      Hero(
                        tag: widget.image,
                        child: CircleAvatar(
                          radius: height * 0.08,
                          backgroundImage: NetworkImage(widget.image),
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Ts(
                    text: widget.name,
                    size: height * 0.035,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Ts(
                    text: '+91 ${widget.number}',
                    size: height * 0.022,
                    color: Colors.grey.shade500,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GetBuilder<InfoController>(
                          builder: (controller) {
                            return ViewContactWidget(
                                onTap: () {
                                  voiceCall(
                                      name: widget.name,
                                      image: widget.image,
                                      number: widget.number,
                                      uid: widget.uid,
                                      cImg: controller.Img,
                                      cName: controller.name,
                                      cNumber: controller.number);
                                },
                                title: 'Audio',
                                icon: Icons.call);
                          },
                        ),
                        ViewContactWidget(
                            title: 'Video', icon: Icons.videocam, onTap: () {}),
                        ViewContactWidget(
                            title: 'Pay', icon: Icons.paid, onTap: () {}),
                        ViewContactWidget(
                            title: 'Search', icon: Icons.search, onTap: () {}),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.018,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              width: width,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Ts(
                        text: widget.bio,
                        size: height * 0.02,
                      ),
                      SizedBox(
                        height: height * 0.0035,
                      ),
                      Ts(
                        text: widget.date,
                        color: Colors.grey.shade500,
                        size: height * 0.018,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                    ]),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              width: width,
              color: Colors.white,
              child: Column(children: []),
            )
          ],
        ),
      ),
    );
  }
}
