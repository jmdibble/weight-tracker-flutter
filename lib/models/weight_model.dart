import 'package:cloud_firestore/cloud_firestore.dart';

class Weight {
  String id;
  int weightKg;
  int weightSt;
  int weightLb;
  Timestamp date;
  String comment;
  String pictureUrl;

  Weight();

  Weight.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    weightKg = data["weightKg"];
    weightSt = data["weightSt"];
    weightLb = data["weightLb"];
    date = data["date"];
    comment = data["comment"];
    pictureUrl = data["pictureUrl"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "weightKg": weightKg,
      "weightSt": weightSt,
      "weightLb": weightLb,
      "date": date,
      "pictureUrl": pictureUrl,
      "comment": comment,
    };
  }
}
