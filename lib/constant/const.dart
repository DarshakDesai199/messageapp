import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/mobile_auth_controller.dart';

var userDoc = FirebaseFirestore.instance
    .collection("user")
    .doc(kFirebaseAuth.currentUser!.uid);
