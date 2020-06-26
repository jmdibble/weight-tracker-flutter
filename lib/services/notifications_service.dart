import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:weighttrackertwo/bloc/nav/nav_bloc.dart';
import 'package:weighttrackertwo/bloc/notifications/notifications_bloc.dart';
import 'package:weighttrackertwo/bloc/notifications/notifications_event.dart';
import 'package:weighttrackertwo/models/message_model.dart';

class NotificationsService {
  final FirebaseMessaging fcm = FirebaseMessaging();
  final NavBloc navBloc;
  final NotificationsBloc notificationsBloc;
  Map<NotificationModel, bool> notifications = {};

  NotificationsService({this.navBloc, this.notificationsBloc}) {
    initialise();
  }

  void initialise() async {
    if (Platform.isIOS) {
      fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        notifications[NotificationModel.fromJson(message)] = false;
        print(notifications.length);
        notificationsBloc.add(ReceivedNotificationEvent());
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        notifications[NotificationModel.fromJson(message)] = false;
        print(notifications.length);
        notificationsBloc.add(ReceivedNotificationEvent());
      },
    );
  }
}
