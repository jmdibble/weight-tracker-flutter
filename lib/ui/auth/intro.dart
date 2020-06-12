import 'package:flutter/material.dart';
import 'package:weighttrackertwo/ui/auth/signin.dart';
import 'package:weighttrackertwo/ui/auth/signup.dart';
import 'package:weighttrackertwo/ui/widgets/primary_button.dart';
import 'package:page_transition/page_transition.dart';

class IntroSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  width: 150,
                  child: Image(
                    image: AssetImage('lib/assets/weighttracker_logo.png'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CurvedShape(),
          ),
        ],
      ),
    );
  }
}

class CurvedShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: _MyPainter(context: context),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Container(
//                  width: double.infinity,
                  child: PrimaryButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 500),
                          child: SignupPage(),
                        ),
                      );
                    },
                    label: "Sign up",
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    color: Colors.grey[800],
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.upToDown,
                      duration: Duration(milliseconds: 500),
                      child: SigninPage(),
                    ),
                  );
                },
                child: Text(
                  "Sign in",
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
}

class _MyPainter extends CustomPainter {
  BuildContext context;

  _MyPainter({this.context});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Theme.of(context).primaryColor;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.72);
    path.quadraticBezierTo(
        size.width / 1.8, size.height / 1.8, size.width, size.height * 0.72);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
