import 'package:flutter/material.dart';
import 'package:weighttrackertwo/bloc/weight/weight_bloc.dart';
import 'package:weighttrackertwo/bloc/weight/weight_event.dart';
import 'package:weighttrackertwo/bloc/weight/weight_state.dart';
import 'package:weighttrackertwo/ui/validators/textfield_validator.dart';
import 'package:weighttrackertwo/ui/widgets/primary_appbar.dart';
import 'package:weighttrackertwo/ui/widgets/primary_button.dart';
import 'package:weighttrackertwo/ui/widgets/primary_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddWeight extends StatefulWidget {
  @override
  _AddWeightState createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController stController = new TextEditingController();
  TextEditingController lbController = new TextEditingController();
  DateTime _dateTime;
  bool noDate = false;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<WeightBloc>(context);

    return Scaffold(
      appBar: PrimaryAppBar(title: "Add weight measurement"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: PrimaryFormField(
                        validator: TextFieldValidator.validate,
                        controller: stController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "St"),
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: PrimaryFormField(
                        validator: TextFieldValidator.validate,
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
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: Theme.of(context).primaryColor,
                                  surface: Colors.grey,
                                ),
                              ),
                              child: child,
                            );
                          },
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
                                      style:
                                          TextStyle(fontSize: 16.0, color: Colors.grey),
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
                      color: noDate ? Colors.red : Colors.white,
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    noDate ? "Choose a date" : "",
                    style: TextStyle(color: Colors.red),
                  ),
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
                          label: "Submit weight",
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _dateTime != null
                                  ? bloc.add(
                                      WeightAddedEvent(
                                        st: int.parse(stController.text),
                                        lbs: int.parse(lbController.text),
                                        kg: 0,
                                        date: _dateTime,
                                      ),
                                    )
                                  : setState(() {
                                      noDate = true;
                                    });
                              stController.text = "";
                              lbController.text = "";
                              _dateTime = null;
                            }
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
      ),
    );
  }
}
