import 'package:flutter/material.dart';
import 'package:weighttrackertwo/bloc/auth/auth_bloc.dart';
import 'package:weighttrackertwo/bloc/auth/auth_event.dart';
import 'package:weighttrackertwo/bloc/nav/nav_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/ui/weight_tracker.dart';
import 'bloc/weight/weight_bloc.dart';
import 'package:weighttrackertwo/ui/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => AuthBloc()
            ..add(
              InitialAuthEvent(),
            ),
        ),
        BlocProvider(
          create: (ctx) => NavBloc(),
        ),
        BlocProvider(
          create: (ctx) => WeightBloc(),
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
// todo: auto log in
// todo: sort out weight details
// todo: wait for picture before loading login
// todo: translate errors
// todo: custom styling?
// todo: cursor color
// todo: add BMI
// todo: get dates on graph tooltips
