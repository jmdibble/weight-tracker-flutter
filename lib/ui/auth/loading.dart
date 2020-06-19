import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weighttrackertwo/ui/widgets/primary_circular_progress.dart';

class AuthLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 150,
              child: Image(
                image: AssetImage('lib/assets/weighttracker_logo.png'),
              ),
            ),
            PrimaryCircularProgress(),
          ],
        ),
      ),
    );
  }
}
