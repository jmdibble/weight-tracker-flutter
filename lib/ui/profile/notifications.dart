import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/bloc/notifications/notifications_bloc.dart';
import 'package:weighttrackertwo/bloc/notifications/notifications_state.dart';
import 'package:weighttrackertwo/ui/widgets/primary_appbar.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Notifications",
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (ctx, state) {
          if (state is InitialNotificationsState) {
            return Text("Initial state");
          } else if (state is ReceivedNotificationState) {
            return Text("Received notification");
          }
        },
      ),
    );
  }
}
