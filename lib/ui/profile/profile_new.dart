import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weighttrackertwo/bloc/auth/auth_bloc.dart';
import 'package:weighttrackertwo/bloc/auth/auth_event.dart';
import 'package:weighttrackertwo/bloc/auth/auth_state.dart';
import 'package:weighttrackertwo/bloc/notifications/notifications_bloc.dart';
import 'package:weighttrackertwo/bloc/notifications/notifications_state.dart';
import 'package:weighttrackertwo/models/user_model.dart';
import 'package:weighttrackertwo/services/notifications_service.dart';
import 'package:weighttrackertwo/ui/profile/account.dart';
import 'package:weighttrackertwo/ui/profile/bmi.dart';
import 'package:weighttrackertwo/ui/theme/colors.dart';
import 'package:weighttrackertwo/ui/widgets/primary_appbar.dart';
import 'package:weighttrackertwo/ui/widgets/primary_circular_progress.dart';

import 'notifications.dart';

class ProfileNewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
//        title: "Profile",
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (ctx, state) {
              bool hasNotifications = false;
              GetIt.I<NotificationsService>()
                  .notifications
                  .forEach((key, value) {
                if (value == false) {
                  hasNotifications = true;
                }
              });

              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications),
                    color: WTColors.darkGrey,
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.upToDown,
                          child: NotificationsPage(),
                        ),
                      );
                    },
                  ),
                  hasNotifications
                      ? Positioned(
                          bottom: 35,
                          right: 0,
                          left: 20,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: WTColors.limeGreen,
                            child: CircleAvatar(
                              radius: 6,
                              backgroundColor: Colors.red,
//                        child: Text(
//                          "4",
//                          style: TextStyle(fontSize: 8, color: Colors.white),
//                        ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              );
            },
          ),
        ],
      ),
      body: CurvedShape(),
    );
  }
}

class CurvedShape extends StatelessWidget {
  User user;

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (ctx, state) {
        if (state is AuthLoadingState) {
          return Center(
            child: PrimaryCircularProgress(),
          );
        } else if (state is AuthorisedState) {
          user = state.user;
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                child: CustomPaint(
                  painter: _MyPainter(context: context),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildUserDetails(user, context, authBloc),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    SizedBox(height: 50),
                    ListTile(
                      leading: Icon(
                        Icons.assessment,
                        color: Colors.grey,
                      ),
                      title: Text("BMI"),
                      subtitle: Text("Add your height to calculate your BMI"),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: BMIPage()));
                      },
                    ),
                    ListTile(
                      title: Text("Account"),
                      subtitle: Text("Change your account details"),
                      leading: Icon(Icons.account_circle, color: Colors.grey),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: AccountSettings()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildUserDetails(User user, BuildContext context, AuthBloc authBloc) {
    return Column(
      children: <Widget>[
        Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(user.displayUrl != ""
                    ? "${user.displayUrl}"
                    : "https://firebasestorage.googleapis.com/v0/b/weight-tracker-two.appspot.com/o/ppc.png?alt=media&token=94732b67-6a6e-4720-8df2-f1068690271b"),
              ),
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                      blurRadius: 8,
                      color: Colors.black.withOpacity(0.5))
                ],
                shape: BoxShape.circle,
                border: new Border.all(
                  color: Colors.white,
                  width: 4.0,
                ),
              ),
            ),
            new Positioned(
              top: 80.0,
              left: 90.0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(boxShadow: [
                  new BoxShadow(color: Colors.grey, blurRadius: 3),
                ], shape: BoxShape.circle),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.edit,
                    color: WTColors.darkGrey,
                  ),
                  onPressed: () {
                    _getLocalImage(authBloc);
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          "${user.firstName}",
          style: TextStyle(
              fontSize: 18.0,
              color: WTColors.darkGrey,
              fontWeight: FontWeight.bold),
        ),
        Text(
          "User since " + DateFormat.yMMM().format(user.createdAt.toDate()),
          style: TextStyle(color: WTColors.darkGrey.withOpacity(0.7)),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  _getLocalImage(AuthBloc authBloc) async {
    ImagePicker imagePicker = ImagePicker();
    File imageFile;

    final pickedFile = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 80, maxWidth: 800);

    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      authBloc.add(
        UploadDisplayPictureEvent(localFile: imageFile),
      );
    }
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

    path.lineTo(0, size.height / 4);
    path.quadraticBezierTo(
        size.width / 2, size.height / 1.8, size.width, size.height / 4);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
