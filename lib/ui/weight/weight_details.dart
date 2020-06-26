import 'package:flutter/material.dart';
import 'package:weighttrackertwo/models/weight_model.dart';
import 'package:intl/intl.dart';
import 'package:weighttrackertwo/ui/theme/colors.dart';
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
            currentWeight.pictureUrl != null
                ? Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Image(
                      fit: BoxFit.fitWidth,
                      image: NetworkImage(currentWeight.pictureUrl),
                    ),
                  )
                : Container(
                    color: WTColors.darkGrey,
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Icon(Icons.photo),
                  ),
            SizedBox(height: 10),
            Text(
              currentWeight.weightSt.toString() +
                  " st " +
                  currentWeight.weightLb.toString() +
                  " lbs ",
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(currentWeight.comment != null ? currentWeight.comment : ""),
            ),
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
