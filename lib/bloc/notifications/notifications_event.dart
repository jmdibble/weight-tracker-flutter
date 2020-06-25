import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {}

class InitialNotificationsEvent extends NotificationsEvent {
  @override
  List<Object> get props => [];
}

class ReceivedNotificationEvent extends NotificationsEvent {
  @override
  List<Object> get props => [];
}
