import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/bloc/weight/weight_bloc.dart';
import 'package:weighttrackertwo/bloc/weight/weight_state.dart';
import 'package:weighttrackertwo/ui/widgets/primary_appbar.dart';
import 'package:weighttrackertwo/ui/widgets/primary_form_field.dart';

class BMIPage extends StatefulWidget {
  @override
  _BMIPageState createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  TextEditingController feetController = new TextEditingController();
  TextEditingController inchesController = new TextEditingController();

  double bmi;
  int ft;
  int inches;

  @override
  void initState() {
    bmi = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(bmi);
    ft = int.parse(feetController.text != "" ? feetController.text : "0");
    inches =
        int.parse(inchesController.text != "" ? inchesController.text : "0");

    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Your BMI",
      ),
      body: BlocBuilder<WeightBloc, WeightState>(
        builder: (ctx, state) {
          if (state is WeightChangedState) {
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 150,
                        child: PrimaryFormField(
                          controller: feetController,
                          decoration: InputDecoration(labelText: "Feet"),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 150,
                        child: PrimaryFormField(
                          controller: inchesController,
                          decoration: InputDecoration(labelText: "Inches"),
                        ),
                      ),
                    ],
                  ),
                  FlatButton(
                    child: Text("Calc"),
                    onPressed: () {
                      _calcBMI(ft, inches, 8, 9);
                    },
                  ),
                  _showBMI(bmi),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _calcBMI(int ft, int inches, int st, int lbs) {
    int totalInches;
    int totalLbs;

    totalInches = ft * 12 + inches;
    totalLbs = st * 14 + lbs;

    setState(() {
      bmi = (totalLbs / (totalInches * totalInches)) * 703;
    });
  }

  _showBMI(bmi) {
    if (bmi == double.infinity) {
      return Container();
    } else if (bmi > 30) {
      return Text("Obese");
    } else if (bmi < 30 && bmi >= 25) {
      return Text("Overweight");
    } else if (bmi < 25 && bmi >= 18.5) {
      return Text("Normal");
    } else {
      return Text("Underweight");
    }
  }
}
