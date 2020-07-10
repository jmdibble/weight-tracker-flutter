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

  Future<double> calcBMI() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    final uid = firebaseUser.uid;

    final DocumentSnapshot documentSnapshot =
        await Firestore.instance.collection("users").document(uid).get();

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("users")
        .document(uid)
        .collection("weights")
        .orderBy("date", descending: true)
        .getDocuments();

    print(documentSnapshot.data);
    print(querySnapshot.documents.first.data['weightSt']);

    int ft = documentSnapshot.data["heightFt"];
    int inches = documentSnapshot.data["heightInches"];

    int st = querySnapshot.documents.first.data["weightSt"];
    int lbs = querySnapshot.documents.first.data["weightLb"];

    int totalInches;
    int totalLbs;
    double bmi;

    totalInches = ft * 12 + inches;
    totalLbs = st * 14 + lbs;

    bmi = (totalLbs / (totalInches * totalInches)) * 703;
    return bmi;
  }
}
