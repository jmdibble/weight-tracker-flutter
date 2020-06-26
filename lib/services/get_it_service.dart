import 'package:get_it/get_it.dart';

class GetItService {
  final getIt = GetIt.instance;

  void setup() {}

  void addService<T>(T service) {
    getIt.registerSingleton<T>(service);
  }
}
