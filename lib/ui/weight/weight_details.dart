import 'package:flutter/material.dart';
import 'package:weighttrackertwo/models/weight_model.dart';
import 'package:intl/intl.dart';
import 'package:weighttrackertwo/ui/weight/edit_weight.dart';
import 'package:weighttrackertwo/ui/widgets/primary_appbar.dart';

class WeightDetails extends StatelessWidget {
  Weight currentWeight;

  WeightDetails({this.currentWeight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: DateFormat.yMMMd().format(currentWeight.date.toDate()),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              currentWeight.weightSt.toString() +
                  " st " +
                  currentWeight.weightLb.toString() +
                  " lbs ",
              style: TextStyle(fontSize: 24.0),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return EditWeight(currentWeight: currentWeight);
            }),
          );
        },
      ),
    );
  }
}
