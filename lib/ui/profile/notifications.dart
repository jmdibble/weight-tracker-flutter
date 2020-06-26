import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:weighttrackertwo/bloc/notifications/notifications_bloc.dart';
import 'package:weighttrackertwo/bloc/notifications/notifications_event.dart';
import 'package:weighttrackertwo/bloc/notifications/notifications_state.dart';
import 'package:weighttrackertwo/models/message_model.dart';
import 'package:weighttrackertwo/services/notifications_service.dart';
import 'package:weighttrackertwo/ui/theme/colors.dart';
import 'package:weighttrackertwo/ui/widgets/primary_appbar.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotificationsService notificationsService = GetIt.I<NotificationsService>();

    notificationsService.notifications.forEach((key, value) {
      notificationsService.notifications[key] = true;
    });
    BlocProvider.of<NotificationsBloc>(context).add(ReadNotificationsEvent());

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
        condition: (prev, next) {
          return prev != next && next is! ReadNotificationsState;
        },
        builder: (ctx, state) {
          if (state is InitialNotificationsState) {
            return notificationsService.notifications.length == 0
                ? Center(
                    child: Text("No notifications"),
                  )
                : Container();
          } else if (state is ReceivedNotificationState ||
              state is ReadNotificationsState) {
            return notificationsService.notifications.length == 0
                ? Center(
                    child: Text("No notifications"),
                  )
                : ListView.builder(
                    itemCount: notificationsService.notifications.length,
                    itemBuilder: (BuildContext context, int i) {
                      NotificationModel key =
                          notificationsService.notifications.keys.elementAt(i);
                      return ListTile(
                        title: Text(key.notification.title ?? ""),
                        subtitle: Text(key.notification.body ?? ""),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.close,
                            color: WTColors.darkGrey,
                            size: 18.0,
                          ),
                        ),
                      );
                    });
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
