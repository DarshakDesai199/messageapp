import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/mobile_auth_controller.dart';

voiceCall({number, name, image, uid, cName, cImg, cNumber}) async {
  // await FlutterPhoneDirectCaller.callNumber(number);
  FirebaseFirestore.instance
      .collection('calls')
      .doc(kFirebaseAuth.currentUser!.uid)
      .collection('data')
      .add(
    {
      'name': name,
      'image': image,
      'time': DateTime.now(),
      'number': number,
      'type': 'dial',
      'call': 'voice',
      'uid': uid
    },
  );
  FirebaseFirestore.instance
      .collection('calls')
      .doc(uid)
      .collection('data')
      .add(
    {
      'name': cName,
      'image': cImg,
      'time': DateTime.now(),
      'number': cNumber,
      'type': 'receive',
      'call': 'voice',
      'uid': kFirebaseAuth.currentUser!.uid
    },
  );
}
