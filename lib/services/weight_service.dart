import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weighttrackertwo/models/weight_model.dart';

class WeightService {
  Future<List<Weight>> getWeight() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;

    List<Weight> weightMeasurements = [];

    QuerySnapshot snapshot = await Firestore.instance
        .collection("users")
        .document(uid)
        .collection("weights")
        .orderBy("date", descending: true)
        .getDocuments();

    snapshot.documents.forEach((document) {
      Weight weight = Weight.fromMap(document.data);
      weightMeasurements.add(weight);
    });
    return weightMeasurements;
  }

  Future<void> addWeight(int st, int lbs, int kg, DateTime date) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;

    DocumentReference docRef = await Firestore.instance
        .collection("users")
        .document(uid)
        .collection("weights")
        .document();

    docRef.setData({
      "id": docRef.documentID,
      "weightSt": st,
      "weightLb": lbs,
      "weightKg": kg,
      "date": date,
    });
  }

  Future<void> deleteWeight(Weight weight) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;

    await Firestore.instance
        .collection("users")
        .document("$uid")
        .collection("weights")
        .document(weight.id)
        .delete();
  }
}
