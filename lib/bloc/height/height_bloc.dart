import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/bloc/height/height_event.dart';
import 'package:weighttrackertwo/bloc/height/height_state.dart';
import 'package:weighttrackertwo/services/height_service.dart';

class HeightBloc extends Bloc<HeightEvent, HeightState> {
  HeightService heightService;
  double bmi;

  HeightBloc() {
    heightService = HeightService();
  }

  @override
  HeightState get initialState => HeightInitialState();

  @override
  Stream<HeightState> mapEventToState(HeightEvent event) async* {
    if (event is GetHeightEvent) {
      bmi = await heightService.calcBMI();
      yield HeightAddedState(bmi: bmi);
    } else if (event is HeightAddedEvent) {
      await heightService.addHeight(event.feet, event.inches);
      bmi = await heightService.calcBMI();
      yield HeightAddedState(bmi: bmi);
    }
  }
}
