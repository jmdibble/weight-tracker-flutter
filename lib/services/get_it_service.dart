import 'package:get_it/get_it.dart';
import 'package:weighttrackertwo/services/notifications_service.dart';

class GetItService {
  final getIt = GetIt.instance;

  void setup() {
    getIt.registerSingleton<NotificationsService>(NotificationsService());
  }
}
