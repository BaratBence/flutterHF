import 'package:f1calendarflutter/data/model/model.dart';
import 'package:f1calendarflutter/network/raceList_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/network/NetworkResonse.dart';



part '../race/raceList_event.dart';
part 'raceList_state.dart';

class RaceListBloc extends Bloc<RaceListEvent, RaceListState> {
  final RaceListRepository _raceListRepository;

  RaceListBloc(this._raceListRepository): super(const RaceListInitial());

  @override
  Stream<RaceListState> mapEventToState(RaceListEvent event,) async* {
    if(event is GetRaces) {
      try {
        yield const RaceListLoading();
        final races = await _raceListRepository.fetchRaces(event.from);
        yield RaceListLoaded(races.produceRaceList().reversed.toList());
      } on NetworkException {
        yield const WeatherError("Couldn't fetch weather. Is the service online?");
      }
    }
    else if(event is GetSeason) {
      try {
        yield const RaceListLoading();
        final races = await _raceListRepository.fetchSeason(event.season);
        yield RaceListSeason(races.produceRaceList().reversed.toList());
      } on NetworkException {
        yield const WeatherError("Couldn't fetch weather. Is the service online?");
      }
    }
  }

}