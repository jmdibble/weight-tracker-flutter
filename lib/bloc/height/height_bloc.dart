import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/bloc/height/height_event.dart';
import 'package:weighttrackertwo/bloc/height/height_state.dart';
import 'package:weighttrackertwo/services/height_service.dart';

class HeightBloc extends Bloc<HeightEvent, HeightState> {
  HeightService heightService;

  HeightBloc() {
    heightService = HeightService();
  }

  @override
  HeightState get initialState => HeightAddedState();

  @override
  Stream<HeightState> mapEventToState(HeightEvent event) async* {
    if (event is HeightAddedEvent) {
      heightService.addHeight(event.feet, event.inches);
      yield HeightAddedState();
    }
  }
}
