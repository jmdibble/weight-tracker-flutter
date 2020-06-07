import 'package:cloud_firestore/cloud_firestore.dart';

class Weight {
  String id;
  int weightKg;
  int weightSt;
  int weightLb;
  Timestamp date;

  Weight();

  Weight.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    weightKg = data["weightKg"];
    weightSt = data["weightSt"];
    weightLb = data["weightLb"];
    date = data["date"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "weightKg": weightKg,
      "weightSt": weightSt,
      "weightLb": weightLb,
      "date": date,
    };
  }
}
