import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weighttrackertwo/ui/widgets/primary_circular_progress.dart';
import 'package:weighttrackertwo/ui/widgets/wt_animation.dart';

class AuthLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WtAnimation(),
          ],
        ),
      ),
    );
  }
}
