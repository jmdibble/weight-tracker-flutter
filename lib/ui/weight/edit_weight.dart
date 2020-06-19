import 'package:flutter/material.dart';
import 'package:weighttrackertwo/bloc/weight/weight_bloc.dart';
import 'package:weighttrackertwo/bloc/weight/weight_event.dart';
import 'package:weighttrackertwo/bloc/weight/weight_state.dart';
import 'package:weighttrackertwo/models/weight_model.dart';
import 'package:weighttrackertwo/ui/home/home.dart';
import 'package:weighttrackertwo/ui/weight_tracker.dart';
import 'package:weighttrackertwo/ui/widgets/primary_appbar.dart';
import 'package:weighttrackertwo/ui/widgets/primary_button.dart';
import 'package:weighttrackertwo/ui/widgets/primary_dialog.dart';
import 'package:weighttrackertwo/ui/widgets/primary_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EditWeight extends StatefulWidget {
  Weight currentWeight;
  EditWeight({this.currentWeight});

  @override
  _EditWeightState createState() => _EditWeightState(currentWeight: currentWeight);
}

class _EditWeightState extends State<EditWeight> {
  TextEditingController stController = new TextEditingController();
  TextEditingController lbController = new TextEditingController();
  DateTime _dateTime;
  Weight currentWeight;

  _EditWeightState({this.currentWeight});

  @override
  void initState() {
    super.initState();
    stController.text = currentWeight.weightSt.toString();
    lbController.text = currentWeight.weightLb.toString();
    _dateTime = currentWeight.date.toDate();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<WeightBloc>(context);

    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Edit weight measurement",
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
            ),
            onPressed: () {
              _showDialog(context, bloc);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: PrimaryFormField(
                      controller: stController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "St"),
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: PrimaryFormField(
                      controller: lbController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Lb"),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      ).then((pickedDate) {
                        setState(() {
                          _dateTime = pickedDate;
                        });
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32.0, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _dateTime == null
                                ? Text(
                                    'Choose date',
                                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                                  )
                                : Text(
                                    DateFormat.yMMMd().format(_dateTime),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                            Icon(Icons.calendar_today)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              BlocBuilder<WeightBloc, WeightState>(
                builder: (ctx, state) {
                  if (state is AddingWeightState) {
                    return CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                    );
                  } else {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: PrimaryButton(
                        label: "Submit changes",
                        onPressed: () {
                          stController.text = "";
                          lbController.text = "";
                          _dateTime = null;
                        },
                      ),
                    );
                  }
                },
              ),
              BlocListener<WeightBloc, WeightState>(
                condition: (prev, next) {
                  next == AddedWeightState;
                },
                child: Container(),
                listener: (prev, next) {
                  if (next is AddedWeightState) {
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context, WeightBloc bloc) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PrimaryDialog(
            content: Text("Delete measurement?"),
            actions: [
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                onPressed: () async {
                  await bloc.add(
                    WeightRemovedEvent(weight: currentWeight),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }
}
