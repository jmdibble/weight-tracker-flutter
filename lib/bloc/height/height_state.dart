import 'package:equatable/equatable.dart';

abstract class HeightState extends Equatable {}

class HeightAddedState extends HeightState {
  int heightFt;
  int heightInches;
  double bmi;

  HeightAddedState({this.heightFt, this.heightInches, this.bmi});

  @override
  List<Object> get props => [heightFt, heightInches, bmi];
}
