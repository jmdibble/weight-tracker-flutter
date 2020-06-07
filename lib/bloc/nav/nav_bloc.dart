import 'package:weighttrackertwo/bloc/nav/nav_event.dart';
import 'package:weighttrackertwo/bloc/nav/nav_state.dart';
import 'package:bloc/bloc.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  @override
  NavState get initialState => ShowNavState(currentIndex: 0);

  @override
  Stream<NavState> mapEventToState(NavEvent event) async* {
    if (event is ChangeNavEvent) {
      yield ShowNavState(currentIndex: event.index);
    }
  }
}
