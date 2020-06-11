import 'package:flutter/material.dart';
import 'package:weighttrackertwo/bloc/auth/auth_bloc.dart';
import 'package:weighttrackertwo/bloc/auth/auth_event.dart';
import 'package:weighttrackertwo/bloc/auth/auth_state.dart';
import 'package:weighttrackertwo/ui/auth/reset_password.dart';
import 'package:weighttrackertwo/ui/auth/signup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/ui/validators/email_validator.dart';
import 'package:weighttrackertwo/ui/validators/password_validator.dart';
import 'package:weighttrackertwo/ui/widgets/primary_circular_progress.dart';
import 'package:weighttrackertwo/ui/widgets/primary_form_field.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  String message = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
//    emailController.text = "josh@josh1.com";
//    passwordController.text = "12345678";

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
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
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
                      "Sign in",
                      style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 30),
                  PrimaryFormField(
                    key: Key('email-field'),
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email address",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    validator: EmailFieldValidator.validate,
                  ),
                  PrimaryFormField(
                    key: Key('password-field'),
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(labelText: "Password"),
                    validator: PasswordFieldValidator.validate,
                  ),
//                  SizedBox(height: 10),
                  Container(
                    child: FlatButton(
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      onPressed: () {
                        _navigateToResetPassword(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      condition: (prev, next) {
                        next == UnauthorisedState;
                      },
                      builder: (ctx, state) {
                        if (state is UnauthorisedState) {
                          return Text(
                            state.message,
                            key: Key('message-text'),
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      key: Key('signin-button'),
                      padding: EdgeInsets.all(12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: isLoading
                          ? PrimaryCircularProgress()
                          : Text(
                              "Sign in",
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                      onPressed: () {
                        print("Signin pressed");
                        if (_formKey.currentState.validate()) {
                          bloc.add(
                            SigninEvent(
                              email: emailController.value.text,
                              password: passwordController.value.text,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _navigateToSignup(context);
                    },
                    child: Text("Sign up instead"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _navigateToSignup(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return SignupPage();
        },
      ),
    );
  }

  _navigateToResetPassword(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ResetPasswordPage();
        },
      ),
    );
  }
}
