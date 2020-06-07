import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weighttrackertwo/bloc/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/bloc/nav/nav_bloc.dart';
import 'package:weighttrackertwo/bloc/nav/nav_event.dart';
import 'package:weighttrackertwo/bloc/nav/nav_state.dart';
import 'package:weighttrackertwo/ui/profile/profile.dart';
import 'package:weighttrackertwo/ui/summary/summary.dart';
import 'package:weighttrackertwo/ui/weight/weight.dart';

enum NavPages { Summary, Weight, Profile }

class HomePage extends StatelessWidget {
  Map<NavPages, IconData> navIcons = {
    NavPages.Summary: Icons.pie_chart,
    NavPages.Weight: Icons.timeline,
    NavPages.Profile: Icons.person,
  };

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final navBloc = BlocProvider.of<NavBloc>(context);

    final List<BottomNavigationBarItem> items = NavPages.values
        .map(
          (page) => _bottomNavButton(
              page: page, icon: navIcons[page], context: context),
        )
        .toList();

    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state),
          bottomNavigationBar: BottomNavigationBar(
            items: items,
            currentIndex: (state as ShowNavState).currentIndex,
            onTap: (index) => navBloc.add(
              ChangeNavEvent(index: index),
            ),
          ),
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
      return ProfilePage();
    default:
      return ErrorWidget("State and page doesnt exist");
  }
}
