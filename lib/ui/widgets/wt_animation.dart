import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class WtAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: FlareActor(
        "lib/assets/animation/wtanim.flr",
        animation: "wtanim",
        fit: BoxFit.contain,
      ),
    );
  }
}
