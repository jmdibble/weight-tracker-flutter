import 'package:equatable/equatable.dart';

abstract class NavEvent extends Equatable {}

class ChangeNavEvent extends NavEvent {
  ChangeNavEvent({this.index});

  int index;

  @override
  List<Object> get props => throw UnimplementedError();
}
