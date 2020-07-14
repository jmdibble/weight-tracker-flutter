import 'package:equatable/equatable.dart';

abstract class HeightEvent extends Equatable {}

class GetHeightEvent extends HeightEvent {
  @override
  List<Object> get props => [];
}

class HeightAddedEvent extends HeightEvent {
  int feet;
  int inches;

  HeightAddedEvent({this.feet, this.inches});

  @override
  List<Object> get props => [];
}
