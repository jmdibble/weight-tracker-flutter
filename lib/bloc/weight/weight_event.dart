import 'package:equatable/equatable.dart';
import 'package:weighttrackertwo/models/weight_model.dart';

abstract class WeightEvent extends Equatable {}

class LoadWeightEvent extends WeightEvent {
  @override
  List<Object> get props => [];
}

class WeightAddedEvent extends WeightEvent {
  int st;
  int lbs;
  int kg;
  DateTime date;

  WeightAddedEvent({this.st, this.lbs, this.kg, this.date});

  @override
  List<Object> get props => [];
}

class WeightChangedEvent extends WeightEvent {
  @override
  List<Object> get props => [];
}

class WeightRemovedEvent extends WeightEvent {
  Weight weight;
  WeightRemovedEvent({this.weight});

  @override
  List<Object> get props => [];
}
