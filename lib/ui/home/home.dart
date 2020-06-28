import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:weighttrackertwo/bloc/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/bloc/nav/nav_bloc.dart';
import 'package:weighttrackertwo/bloc/nav/nav_event.dart';
import 'package:weighttrackertwo/bloc/nav/nav_state.dart';
import 'package:weighttrackertwo/bloc/notifications/notifications_bloc.dart';
import 'package:weighttrackertwo/services/notifications_service.dart';
import 'package:weighttrackertwo/ui/profile/profile.dart';
import 'package:weighttrackertwo/ui/profile/profile_new.dart';
import 'package:weighttrackertwo/ui/summary/summary.dart';
import 'package:weighttrackertwo/ui/weight/weight.dart';
import 'package:weighttrackertwo/ui/widgets/primary_dialog.dart';

enum NavPages { Summary, Weight, Profile }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<NavPages, IconData> navIcons = {
    NavPages.Summary: Icons.pie_chart,
    NavPages.Weight: Icons.timeline,
    NavPages.Profile: Icons.person,
  };

  @override
  void initState() {
    GetIt.I.registerSingleton<NotificationsService>(
      NotificationsService(
        navBloc: BlocProvider.of<NavBloc>(context),
        notificationsBloc: BlocProvider.of<NotificationsBloc>(context),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    GetIt.I.unregister<NotificationsService>(instance: NotificationsService());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navBloc = BlocProvider.of<NavBloc>(context);

    final List<BottomNavigationBarItem> items = NavPages.values
        .map(
          (page) => _bottomNavButton(page: page, icon: navIcons[page], context: context),
        )
        .toList();

    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () {
            _showExitDialog(context);
          },
          child: Scaffold(
            body: _buildBody(state),
            bottomNavigationBar: BottomNavigationBar(
              items: items,
              currentIndex: (state as ShowNavState).currentIndex,
              onTap: (index) => navBloc.add(
                ChangeNavEvent(index: index),
              ),
            ),
          ),
        );
      },
    );
  }

  _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PrimaryDialog(
          content: Text(
            "Exit app?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            FlatButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              onPressed: () async {
                await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
//
              },
              child: Text(
                "Exit",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

BottomNavigationBarItem _bottomNavButton(
    {NavPages page, IconData icon, BuildContext context}) {
  return BottomNavigationBarItem(
    title: Text(
      page.toString().replaceAll('NavPages.', ''),
      style: TextStyle(color: Theme.of(context).primaryColor),
    ),
    icon: Icon(
      icon,
      color: Theme.of(context).primaryColor,
    ),
  );
}

Widget _buildBody(ShowNavState state) {
  switch (state.currentIndex) {
    case 0:
      return SummaryPage();
    case 1:
      return WeightPage();
    case 2:
      return ProfileNewPage();
    default:
      return ErrorWidget("State and page doesnt exist");
  }
}
