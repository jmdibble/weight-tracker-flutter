import 'package:equatable/equatable.dart';

abstract class NotificationsState extends Equatable {}

class InitialNotificationsState extends NotificationsState {
  @override
  List<Object> get props => [];
}

class ReceivedNotificationState extends NotificationsState {
  @override
  List<Object> get props => [];
}

class ReadNotificationsState extends NotificationsState {
  @override
  List<Object> get props => [];
}
