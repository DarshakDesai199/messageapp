// // import 'dart:ui';
// //
// // import 'package:draggable_bottom_sheet_nullsafety/draggable_bottom_sheet_nullsafety.dart';
// // import 'package:flutter/material.dart';
// //
// // void main() {
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //         visualDensity: VisualDensity.adaptivePlatformDensity,
// //       ),
// //       home:
// //           DraggableBottomSheetExample(title: 'Draggable Bottom Sheet Example'),
// //       debugShowCheckedModeBanner: false,
// //     );
// //   }
// // }
// //
// // class DraggableBottomSheetExample extends StatelessWidget {
// //   DraggableBottomSheetExample({Key? key, required this.title})
// //       : super(key: key);
// //   final String title;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     List<IconData> icons = [
// //       Icons.ac_unit,
// //       Icons.account_balance,
// //       Icons.adb,
// //       Icons.add_photo_alternate,
// //       Icons.format_line_spacing
// //     ];
// //
// //     return Scaffold(
// //         body: DraggableBottomSheet(
// //       backgroundWidget: Scaffold(
// //         backgroundColor: Colors.white,
// //         appBar: AppBar(
// //           title: Text(title),
// //           backgroundColor: Colors.deepOrange,
// //         ),
// //       ),
// //       previewChild: Container(
// //         padding: EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //             color: Colors.pink,
// //             borderRadius: BorderRadius.only(
// //                 topLeft: Radius.circular(20), topRight: Radius.circular(20))),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: <Widget>[
// //             Container(
// //               width: 40,
// //               height: 6,
// //               decoration: BoxDecoration(
// //                   color: Colors.white, borderRadius: BorderRadius.circular(10)),
// //             ),
// //             SizedBox(
// //               height: 8,
// //             ),
// //             Text(
// //               'Drag Me',
// //               style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold),
// //             ),
// //           ],
// //         ),
// //       ),
// //       expandedChild: Container(
// //         padding: EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //             color: Colors.pink,
// //             borderRadius: BorderRadius.only(
// //                 topLeft: Radius.circular(20), topRight: Radius.circular(20))),
// //         child: Column(
// //           children: <Widget>[
// //             Icon(
// //               Icons.keyboard_arrow_down,
// //               size: 30,
// //               color: Colors.white,
// //             ),
// //             Text(
// //               'Hey...I\'m expanding!!!',
// //               style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(
// //               height: 16,
// //             ),
// //             Expanded(
// //               child: GridView.builder(
// //                   itemCount: icons.length,
// //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                     crossAxisCount: 2,
// //                     crossAxisSpacing: 10,
// //                     mainAxisSpacing: 10,
// //                   ),
// //                   itemBuilder: (context, index) => Container(
// //                         decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             borderRadius: BorderRadius.circular(10)),
// //                         child: Icon(
// //                           icons[index],
// //                           color: Colors.pink,
// //                           size: 40,
// //                         ),
// //                       )),
// //             )
// //           ],
// //         ),
// //       ),
// //       minExtent: 80,
// //       // maxExtent: MediaQuery.of(context).size.height * 0.1,
// //     ));
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:messageapp/controller/mobile_auth_controller.dart';
// import 'package:messageapp/main.dart';
// import 'package:status_view/status_view.dart';
//
// import '../constant/Text.dart';
// import '../constant/color.dart';
// import 'home/status/status_view_screen.dart';
//
// class Aa extends StatefulWidget {
//   const Aa({Key? key}) : super(key: key);
//
//   @override
//   State<Aa> createState() => _AaState();
// }
//
// class _AaState extends State<Aa> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [
//         StreamBuilder(
//           stream: FirebaseFirestore.instance.collection('status').snapshots(),
//           builder: (BuildContext context,
//               AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//             if (snapshot.hasData) {
//               return Expanded(
//                 child: ListView.builder(
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     var userStatus = snapshot.data!.docs;
//                     return kFirebaseAuth.currentUser!.uid ==
//                             userStatus[index].id
//                         ? SizedBox()
//                         : StreamBuilder(
//                             stream: FirebaseFirestore.instance
//                                 .collection('user')
//                                 .doc(kFirebaseAuth.currentUser!.uid)
//                                 .collection('roomId')
//                                 // .orderBy('time', descending: false)
//                                 .snapshots(),
//                             builder: (BuildContext context,
//                                 AsyncSnapshot<
//                                         QuerySnapshot<Map<String, dynamic>>>
//                                     snapshot) {
//                               if (snapshot.hasData) {
//                                 return ListView.builder(
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   itemCount: snapshot.data!.docs.length,
//                                   itemBuilder: (context, i) {
//                                     id = snapshot.data!.docs[i].id;
//
//                                     return kFirebaseAuth.currentUser!.uid +
//                                                     userStatus[index].id ==
//                                                 id ||
//                                             userStatus[index].id +
//                                                     kFirebaseAuth
//                                                         .currentUser!.uid ==
//                                                 id
//                                         ? StreamBuilder(
//                                             stream: FirebaseFirestore.instance
//                                                 .collection('status')
//                                                 .doc(userStatus[index].id)
//                                                 .collection('data')
//                                                 .orderBy('time',
//                                                     descending: true)
//                                                 .snapshots(),
//                                             builder: (BuildContext context,
//                                                 AsyncSnapshot<
//                                                         QuerySnapshot<
//                                                             Map<String,
//                                                                 dynamic>>>
//                                                     snapshot) {
//                                               if (snapshot.hasData) {
//                                                 var io = snapshot.data!.docs;
//                                                 var date = io[0]['time'];
//                                                 DateTime myDateTime =
//                                                     (date).toDate();
//                                                 var t = DateFormat.jm()
//                                                     .format(myDateTime);
//                                                 return InkWell(
//                                                   onTap: () async {
//                                                     Get.to(StoriesView(
//                                                       uid: userStatus[index].id,
//                                                     ));
//                                                   },
//                                                   child: Container(
//                                                     height: height * 0.09,
//                                                     width: width,
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal:
//                                                                 width * 0.04),
//                                                     child: Row(
//                                                       children: [
//                                                         StatusView(
//                                                           radius:
//                                                               height * 0.033,
//                                                           spacing: 15,
//                                                           strokeWidth: 2,
//                                                           indexOfSeenStatus: 2,
//                                                           numberOfStatus:
//                                                               io.length,
//                                                           padding: 4,
//                                                           centerImageUrl:
//                                                               "${io[0]['image']}",
//                                                           seenColor:
//                                                               Colors.grey,
//                                                           unSeenColor: appColor,
//                                                         ),
//                                                         SizedBox(
//                                                           width: width * 0.04,
//                                                         ),
//                                                         Column(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                           children: [
//                                                             Ts(
//                                                               text:
//                                                                   '${userStatus[index]['name']}',
//                                                               size:
//                                                                   height * 0.02,
//                                                               weight: FontWeight
//                                                                   .w500,
//                                                             ),
//                                                             SizedBox(
//                                                               height: height *
//                                                                   0.005,
//                                                             ),
//                                                             Ts(
//                                                               text: t,
//                                                               size: height *
//                                                                   0.017,
//                                                               color:
//                                                                   Colors.grey,
//                                                               weight: FontWeight
//                                                                   .w400,
//                                                             ),
//                                                           ],
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 );
//                                               } else {
//                                                 return SizedBox();
//                                               }
//                                             },
//                                           )
//                                         : SizedBox();
//                                   },
//                                 );
//                               } else {
//                                 return Center(child: SizedBox());
//                               }
//                             },
//                           );
//                   },
//                 ),
//               );
//             } else {
//               return SizedBox();
//             }
//           },
//         ),
//
//         //         StreamBuilder(
//         //   stream: FirebaseFirestore.instance.collection('status').snapshots(),
//         //   builder: (BuildContext context,
//         //           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//         //         return SizedBox(
//         //           height: height * 0.8,
//         //           child: ListView.builder(
//         //             itemCount: snapshot.data!.docs.length,
//         //             itemBuilder: (context, index) {
//         //               var rf = snapshot.data!.docs[index];
//         //               return rf.id == kFirebaseAuth.currentUser!.uid
//         //                   ? SizedBox()
//         //                   : StreamBuilder(
//         //                       stream: FirebaseFirestore.instance
//         //                           .collection('user')
//         //                           .doc(kFirebaseAuth.currentUser!.uid)
//         //                           .collection('roomId')
//         //                           .snapshots(),
//         //                       builder: (BuildContext context,
//         //                           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
//         //                               snapshot) {
//         //                         if (snapshot.hasData) {
//         //                           return ListView.builder(
//         //                             shrinkWrap: true,
//         //                             physics: NeverScrollableScrollPhysics(),
//         //                             itemCount: snapshot.data!.docs.length,
//         //                             itemBuilder: (context, i) {
//         //                               var id = snapshot.data!.docs[i].id;
//         //
//         //                               return kFirebaseAuth.currentUser!.uid + rf.id ==
//         //                                           id ||
//         //                                       rf.id + kFirebaseAuth.currentUser!.uid ==
//         //                                           id
//         //                                   ? StreamBuilder(
//         //                                       stream: FirebaseFirestore.instance
//         //                                           .collection('status')
//         //                                           .doc(rf.id)
//         //                                           .collection('data')
//         //                                           .snapshots(),
//         //                                       builder: (BuildContext context,
//         //                                           AsyncSnapshot<
//         //                                                   QuerySnapshot<
//         //                                                       Map<String, dynamic>>>
//         //                                               snapshot) {
//         //                                         if (snapshot.hasData) {
//         //                                           return SizedBox(
//         //                                             height: height * 0.5,
//         //                                             child: ListView.builder(
//         //                                               itemCount:
//         //                                                   snapshot.data!.docs.length,
//         //                                               itemBuilder: (context, index) {
//         //                                                 var id =
//         //                                                     snapshot.data!.docs[index];
//         //                                                 print('########${id.id}');
//         //                                                 return SizedBox(
//         //                                                   height: height * 0.4,
//         //                                                   child: ListView.builder(
//         //                                                     itemCount: snapshot
//         //                                                         .data!.docs.length,
//         //                                                     itemBuilder:
//         //                                                         (context, index) {
//         //                                                       return InkWell(
//         //                                                         onTap: () async {
//         //                                                           Get.to(StoriesView(
//         //                                                             uid: id.id,
//         //                                                           ));
//         //                                                         },
//         //                                                         child: Container(
//         //                                                           height: height * 0.09,
//         //                                                           width: width,
//         //                                                           padding: EdgeInsets
//         //                                                               .symmetric(
//         //                                                                   horizontal:
//         //                                                                       width *
//         //                                                                           0.04),
//         //                                                           child: Row(
//         //                                                             children: [
//         //                                                               StatusView(
//         //                                                                 radius: height *
//         //                                                                     0.033,
//         //                                                                 spacing: 15,
//         //                                                                 strokeWidth: 2,
//         //                                                                 indexOfSeenStatus:
//         //                                                                     2,
//         //                                                                 numberOfStatus:
//         //                                                                     snapshot
//         //                                                                         .data!
//         //                                                                         .docs
//         //                                                                         .length,
//         //                                                                 padding: 4,
//         //                                                                 centerImageUrl:
//         //                                                                     "${id['image']}",
//         //                                                                 seenColor:
//         //                                                                     Colors.grey,
//         //                                                                 unSeenColor:
//         //                                                                     appColor,
//         //                                                               ),
//         //                                                               SizedBox(
//         //                                                                 width: width *
//         //                                                                     0.04,
//         //                                                               ),
//         //                                                               Column(
//         //                                                                 mainAxisAlignment:
//         //                                                                     MainAxisAlignment
//         //                                                                         .center,
//         //                                                                 crossAxisAlignment:
//         //                                                                     CrossAxisAlignment
//         //                                                                         .start,
//         //                                                                 children: [
//         //                                                                   Ts(
//         //                                                                     text:
//         //                                                                         '${id['name']}',
//         //                                                                     size:
//         //                                                                         height *
//         //                                                                             0.02,
//         //                                                                     weight:
//         //                                                                         FontWeight
//         //                                                                             .w500,
//         //                                                                   ),
//         //                                                                   SizedBox(
//         //                                                                     height:
//         //                                                                         height *
//         //                                                                             0.005,
//         //                                                                   ),
//         //                                                                   Ts(
//         //                                                                     text: '',
//         //                                                                     size: height *
//         //                                                                         0.017,
//         //                                                                     color: Colors
//         //                                                                         .grey,
//         //                                                                     weight:
//         //                                                                         FontWeight
//         //                                                                             .w400,
//         //                                                                   ),
//         //                                                                 ],
//         //                                                               )
//         //                                                             ],
//         //                                                           ),
//         //                                                         ),
//         //                                                       );
//         //                                                     },
//         //                                                   ),
//         //                                                 );
//         //                                               },
//         //                                             ),
//         //                                           );
//         //                                         } else {
//         //                                           return Center(
//         //                                             child: CircularProgressIndicator(
//         //                                               color: appColor,
//         //                                             ),
//         //                                           );
//         //                                         }
//         //                                       },
//         //                                     )
//         //                                   : SizedBox();
//         //                             },
//         //                           );
//         //                         } else {
//         //                           return Center(child: SizedBox());
//         //                         }
//         //                       },
//         //                     );
//         //             },
//         //           ),
//         //         );
//         //   },
//         // ),
//       ],
//     ));
//   }
// }
