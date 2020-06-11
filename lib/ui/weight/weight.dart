import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weighttrackertwo/bloc/weight/weight_bloc.dart';
import 'package:weighttrackertwo/bloc/weight/weight_event.dart';
import 'package:weighttrackertwo/bloc/weight/weight_state.dart';
import 'package:weighttrackertwo/models/weight_model.dart';
import 'package:weighttrackertwo/ui/weight/add_weight.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weighttrackertwo/ui/weight/weight_details.dart';
import 'package:weighttrackertwo/ui/widgets/primary_appbar.dart';
import 'package:weighttrackertwo/ui/widgets/primary_circular_progress.dart';

class WeightPage extends StatelessWidget {
  Weight currentWeight;

  @override
  Widget build(BuildContext context) {
    WeightBloc weightBloc = BlocProvider.of<WeightBloc>(context)
      ..add(
        LoadWeightEvent(),
      );
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Weight",
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              BlocBuilder<WeightBloc, WeightState>(
                builder: (ctx, state) {
                  if (state is WeightInitialState) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PrimaryCircularProgress(),
                    );
                  } else if (state is WeightChangedState) {
                    if (state.weight.length == 0) {
                      return Text(
                        "You haven't added any measurements yet",
                        style: TextStyle(color: Colors.grey),
                      );
                    } else {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.weight.length,
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            onTap: () {
                              currentWeight = state.weight[i];
                              _navigateToDetails(context, currentWeight);
                            },
                            leading: _showIcon(context, i, state),
                            title: Text(
                                "${state.weight[i].weightSt}st ${state.weight[i].weightLb}lb"),
                            subtitle: Text(
                                "${DateFormat.yMMMd().format(state.weight[i].date.toDate())}"),
                            trailing: IconButton(
                              icon: Icon(Icons.chevron_right),
                              onPressed: () {},
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddWeight(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _showIcon(BuildContext context, int i, state) {
    if (i == state.weight.length - 1) {
      return Icon(
        Icons.flag,
        color: Colors.grey,
      );
    }
    if (i >= 0 && i < state.weight.length - 1) {
      if ((((state.weight[i].weightSt) * 14) + state.weight[i].weightLb) >
          (((state.weight[i + 1].weightSt) * 14) + state.weight[i + 1].weightLb)) {
        return Icon(
          Icons.arrow_upward,
          color: Colors.red,
        );
      } else if ((((state.weight[i].weightSt) * 14) + state.weight[i].weightLb) ==
          (((state.weight[i + 1].weightSt) * 14) + state.weight[i + 1].weightLb)) {
        return Icon(
          Icons.minimize,
          color: Colors.yellow,
        );
      } else {
        return Icon(
          Icons.arrow_downward,
          color: Theme.of(context).primaryColor,
        );
      }
    }
  }

  _openAddWeight(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddWeight();
        },
      ),
    );
  }

  _navigateToDetails(BuildContext context, Weight currentWeight) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return WeightDetails(currentWeight: currentWeight);
      }),
    );
  }
}
