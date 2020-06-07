import 'package:equatable/equatable.dart';

abstract class NavState extends Equatable {}

class ShowNavState extends NavState {
  ShowNavState({this.currentIndex});

  int currentIndex;

  @override
  List<Object> get props => [currentIndex];
}
