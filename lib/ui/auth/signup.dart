import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weighttrackertwo/bloc/auth/auth_bloc.dart';
import 'package:weighttrackertwo/bloc/auth/auth_event.dart';
import 'package:weighttrackertwo/bloc/auth/auth_state.dart';
import 'package:weighttrackertwo/ui/auth/signin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/ui/home/home.dart';
import 'package:weighttrackertwo/ui/validators/email_validator.dart';
import 'package:weighttrackertwo/ui/validators/password_validator.dart';
import 'package:weighttrackertwo/ui/validators/textfield_validator.dart';
import 'package:weighttrackertwo/ui/widgets/primary_circular_progress.dart';
import 'package:weighttrackertwo/ui/widgets/primary_form_field.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmController = new TextEditingController();
  TextEditingController firstController = new TextEditingController();
  TextEditingController lastController = new TextEditingController();
  bool isLoading = false;
  bool passwordsMatch = true;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (prev, next) {
        if (next is AuthLoadingState) {
          setState(() {
            isLoading = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40),
                  Container(
                    width: 120,
                    child: Image(
                      image: AssetImage('lib/assets/weighttracker_logo.png'),
                    ),
                  ),
                  SizedBox(height: 60),
                  Container(
                    child: Text(
                      "Sign up",
                      style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 30),
                  PrimaryFormField(
                    controller: firstController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: "First name"),
                    validator: TextFieldValidator.validate,
                  ),
                  PrimaryFormField(
                    controller: lastController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: "Last name"),
                    validator: TextFieldValidator.validate,
                  ),
                  PrimaryFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email address"),
                    validator: EmailFieldValidator.validate,
                  ),
                  PrimaryFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(labelText: "Password"),
                    validator: PasswordFieldValidator.validate,
                  ),
                  PrimaryFormField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Confirm password"),
                  ),
                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      passwordsMatch ? "" : "Passwords must match",
                      style: TextStyle(
                          color: Colors.red, fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      padding: EdgeInsets.all(12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: isLoading
                          ? Container(
                              height: 10,
                              width: 10,
                              child: PrimaryCircularProgress(),
                            )
                          : Text(
                              "Sign up",
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (passwordController.text == confirmController.text &&
                              passwordController.text != "") {
                            bloc.add(
                              SignupEvent(
                                email: emailController.value.text,
                                password: passwordController.value.text,
                                firstName: firstController.value.text,
                                lastName: lastController.value.text,
                              ),
                            );
                          }
                        } else {
                          setState(() {
                            passwordsMatch = false;
                          });
                        }
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _navigateToSignin(context);
                    },
                    child: Text("Sign in instead"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _navigateToSignin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) {
        return SigninPage();
      }),
    );
  }
}
