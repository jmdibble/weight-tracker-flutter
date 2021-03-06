import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:weighttrackertwo/bloc/auth/auth_bloc.dart';
import 'package:weighttrackertwo/bloc/auth/auth_event.dart';
import 'package:weighttrackertwo/bloc/height/height_bloc.dart';
import 'package:weighttrackertwo/bloc/nav/nav_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/bloc/notifications/notifications_bloc.dart';
import 'package:weighttrackertwo/services/auth_service.dart';
import 'package:weighttrackertwo/services/get_it_service.dart';
import 'package:weighttrackertwo/services/notifications_service.dart';
import 'package:weighttrackertwo/ui/weight_tracker.dart';
import 'bloc/weight/weight_bloc.dart';
import 'package:weighttrackertwo/ui/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetItService getIt = GetItService();
  getIt.setup();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("lib/assets/weighttracker_logo.png"), context);
    precacheImage(AssetImage("lib/assets/google-logo.png"), context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => AuthBloc(authService: AuthService()),
        ),
        BlocProvider(
          create: (ctx) => NavBloc(),
        ),
        BlocProvider(
          create: (ctx) => WeightBloc(),
        ),
        BlocProvider(
          create: (ctx) => NotificationsBloc(),
        ),
        BlocProvider(
          create: (ctx) => HeightBloc(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Weight Tracker',
          theme: defaultTheme,
          home: WeightTracker()),
    );
  }
}

/// todos
// todo: fix height bloc
// todo: add widget. for the stateful widgets
// todo: finish notifications page
// todo: translate errors (half)
// todo: finish summary BMI widget
// todo: make sure bmi works on login
// todo: get dates on graph tooltips
