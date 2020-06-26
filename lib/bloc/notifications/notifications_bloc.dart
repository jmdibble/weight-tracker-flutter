import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/bloc/notifications/notifications_event.dart';
import 'package:weighttrackertwo/bloc/notifications/notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc();

  @override
  NotificationsState get initialState => InitialNotificationsState();

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    if (event is ReceivedNotificationEvent) {
      yield ReceivedNotificationState();
    } else if (event is ReadNotificationsEvent) {
      yield ReadNotificationsState();
    }
  }
}
