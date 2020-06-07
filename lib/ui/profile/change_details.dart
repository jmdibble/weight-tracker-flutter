import 'package:flutter/material.dart';
import 'package:weighttrackertwo/bloc/auth/auth_bloc.dart';
import 'package:weighttrackertwo/bloc/auth/auth_event.dart';
import 'package:weighttrackertwo/bloc/auth/auth_state.dart';
import 'package:weighttrackertwo/models/user_model.dart';
import 'package:weighttrackertwo/ui/validators/textfield_validator.dart';
import 'package:weighttrackertwo/ui/widgets/primary_appbar.dart';
import 'package:weighttrackertwo/ui/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/ui/widgets/primary_form_field.dart';

class ChangeName extends StatefulWidget {
  User user;

  ChangeName({this.user});

  @override
  _ChangeNameState createState() => _ChangeNameState(user: user);
}

class _ChangeNameState extends State<ChangeName> {
  User user;

  _ChangeNameState({this.user});

  final _formKey = GlobalKey<FormState>();
  TextEditingController fnController = new TextEditingController();
  TextEditingController lnController = new TextEditingController();

  @override
  void initState() {
    fnController.text = user.firstName;
    lnController.text = user.lastName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc bloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: PrimaryAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 40.0),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Change details",
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  PrimaryFormField(
                    validator: TextFieldValidator.validate,
                    decoration: InputDecoration(labelText: "First name"),
                    controller: fnController,
                  ),
                  PrimaryFormField(
                    validator: TextFieldValidator.validate,
                    decoration: InputDecoration(labelText: "Last name"),
                    controller: lnController,
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (ctx, state) {
                        if (state is AuthLoadingState) {
                          return PrimaryButton(
                            loading: true,
                            onPressed: () {},
                          );
                        } else {
                          return PrimaryButton(
                            label: "Submit",
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                bloc.add(
                                  ChangeDetailsEvent(
                                      firstName: fnController.text,
                                      lastName: lnController.text),
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
