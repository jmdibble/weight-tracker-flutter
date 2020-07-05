import 'package:flutter/material.dart';
import 'package:weighttrackertwo/ui/widgets/primary_appbar.dart';
import 'package:weighttrackertwo/ui/widgets/primary_form_field.dart';

class BMIPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Your BMI",
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 150,
                  child: PrimaryFormField(
                    decoration: InputDecoration(labelText: "Feet"),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 150,
                  child: PrimaryFormField(
                    decoration: InputDecoration(labelText: "Inches"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
