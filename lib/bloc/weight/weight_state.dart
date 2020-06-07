import 'package:equatable/equatable.dart';
import 'package:weighttrackertwo/models/weight_model.dart';

abstract class WeightState extends Equatable {}

class WeightInitialState extends WeightState {
  List<Weight> weight;
  WeightInitialState({this.weight});

  @override
  List<Object> get props => [];
}

class AddingWeightState extends WeightState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class AddedWeightState extends WeightState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class WeightChangedState extends WeightState {
  List<Weight> weight;
  WeightChangedState({this.weight});

  @override
  List<Object> get props => [weight];
}
