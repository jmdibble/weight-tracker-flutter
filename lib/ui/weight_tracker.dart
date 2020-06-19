import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/bloc/auth/auth_bloc.dart';
import 'package:weighttrackertwo/bloc/auth/auth_state.dart';
import 'package:weighttrackertwo/ui/auth/intro.dart';
import 'package:weighttrackertwo/ui/auth/loading.dart';
import 'package:weighttrackertwo/ui/auth/signin.dart';
import 'package:weighttrackertwo/ui/home/home.dart';
import 'package:page_transition/page_transition.dart';

class WeightTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      condition: (prev, next) {
        return prev != next && next is! AuthLoadingState;
      },
      builder: (context, state) {
        if (state is AuthInitialState) {
          return AuthLoading();
        } else if (state is UnauthorisedState) {
          return IntroSplash();
        } else if (state is AuthFailState) {
          return SigninPage();
        } else if (state is AuthorisedState) {
          return HomePage();
        }
      },
    );
  }

  _navigateHome(BuildContext context) {
    Navigator.pushReplacement(
        context, PageTransition(type: PageTransitionType.fade, child: HomePage()));
  }
}
