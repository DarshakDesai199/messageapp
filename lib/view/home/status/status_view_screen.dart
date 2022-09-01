// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:messageapp/constant/color.dart';
// import 'package:messageapp/constant/image_loading.dart';
// import 'package:messageapp/main.dart';
//
// import '../../../constant/Text.dart';
//
// class StatusView extends StatefulWidget {
//   final uid;
//   final status;
//   final comment;
//   const StatusView({Key? key, this.status, this.comment, this.uid})
//       : super(key: key);
//
//   @override
//   State<StatusView> createState() => _StatusViewState();
// }
//
// class _StatusViewState extends State<StatusView> {
//   PageController pageController = Get.put(PageController(initialPage: 0));
//   Timer? timer;
//   @override
//   initState() {
//     timer = Timer(
//       Duration(seconds: 5),
//       () {
//         Get.back();
//       },
//     );
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('status')
//             .doc(widget.uid)
//             .collection('data')
//             .snapshots(),
//         builder: (BuildContext context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           if (snapshot.hasData) {
//             return PageView.builder(
//               controller: pageController,
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (BuildContext context, int index) {
//                 var data = snapshot.data!.docs[index];
//
//                 return GestureDetector(
//                   onDoubleTap: () {},
//                   onTap: () {
//                     pageController.nextPage(
//                         duration: Duration(microseconds: 1),
//                         curve: Curves.easeInCirc);
//                     Get.back();
//                   },
//                   child: Stack(
//                     children: [
//                       ImageLoading(
//                           url: data['image'], hight: Get.height, width: width),
//                       data['StatusMessage'] == ''
//                           ? SizedBox()
//                           : Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Container(
//                                   height: Get.height * 0.05,
//                                   width: Get.width,
//                                   color: Colors.black54,
//                                   child: Center(
//                                     child: Ts(
//                                       text: '${data['StatusMessage']}',
//                                       color: Colors.white,
//                                       weight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: Get.height * 0.07,
//                                 )
//                               ],
//                             ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: appColor,
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:messageapp/constant/color.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StoriesView extends StatefulWidget {
  final uid;

  const StoriesView({super.key, required this.uid});
  @override
  _StoriesViewState createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('status')
            .doc(widget.uid)
            .collection('data')
            // .orderBy('time', descending: false)
            .where('endTime', isLessThanOrEqualTo: DateTime.now())
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return StoryView(
              storyItems: [
                ...List.generate(snapshot.data!.docs.length, (index) {
                  var data = snapshot.data!.docs[index];
                  return StoryItem.pageImage(
                    url: data['image'],
                    caption: data['StatusMessage'],
                    controller: storyController,
                  );
                }),
              ],
              onStoryShow: (s) {
                print("Showing a story");
              },
              onComplete: () {
                print("Completed a cycle");
                Get.back();
              },
              progressPosition: ProgressPosition.top,
              repeat: false,
              controller: storyController,
            );
            ;
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
