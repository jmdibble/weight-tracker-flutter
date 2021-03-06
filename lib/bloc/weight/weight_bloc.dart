import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weighttrackertwo/bloc/weight/weight_event.dart';
import 'package:weighttrackertwo/bloc/weight/weight_state.dart';
import 'package:weighttrackertwo/services/weight_service.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  WeightService weightService;

  WeightBloc() {
    weightService = WeightService();
  }

  @override
  get initialState => WeightInitialState();

  @override
  Stream<WeightState> mapEventToState(WeightEvent event) async* {
    if (event is WeightChangedEvent) {
      var weight = await weightService.getWeight();
      yield WeightChangedState(weight: weight);
    } else if (event is LoadWeightEvent) {
      var weight = await weightService.getWeight();
      yield WeightChangedState(weight: weight);
    } else if (event is WeightAddedEvent) {
      try {
        yield AddingWeightState();
        await weightService.addWeight(
            event.st, event.lbs, event.kg, event.date, event.comment, event.imageFile);
        var weight = await weightService.getWeight();
        yield AddedWeightState();
        yield WeightChangedState(weight: weight);
      } catch (e) {
        print(e.toString());
      }
    } else if (event is WeightEditEvent) {
      try {
        yield AddingWeightState();
        await weightService.editWeight(event.id, event.st, event.lbs, event.kg,
            event.date, event.comment, event.imageFile, event.pictureUrl);
        var weight = await weightService.getWeight();
        yield AddedWeightState();
        yield WeightChangedState(weight: weight);
      } catch (e) {
        print(e.toString());
      }
    } else if (event is WeightRemovedEvent) {
      await weightService.deleteWeight(event.weight);
      var weight = await weightService.getWeight();
      yield WeightChangedState(weight: weight);
    }
  }
}
