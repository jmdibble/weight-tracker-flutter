import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HeightService {
  Future<void> addHeight(int feet, int inches) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    final uid = firebaseUser.uid;

    await Firestore.instance.collection("users").document(uid).setData({
      "heightFt": feet,
      "heightInches": inches,
    }, merge: true);
  }
}
