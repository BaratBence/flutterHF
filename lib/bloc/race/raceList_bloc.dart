import 'package:f1calendarflutter/data/model/model.dart';
import 'package:f1calendarflutter/network/raceList_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../race/raceList_event.dart';
part 'raceList_state.dart';

class RaceListBloc extends Bloc<RaceListEvent, RaceListState> {
  final RaceListRepository _raceListRepository;
  List<RaceListItem> items = [];
  int loaded = 979;
  bool season = false;

  RaceListBloc(this._raceListRepository): super(const RaceListInitial());

  @override
  Stream<RaceListState> mapEventToState(RaceListEvent event,) async* {
    if(event is GetRaces) {
      try {
        yield const RaceListLoading();
        if(loaded != 0) {
          final races = await _raceListRepository.fetchRaces(loaded.toString());
          if(season) {
            items = [];
            items.addAll(races.produceRaceList().reversed.toList());
            season = false;
          }
          else items.addAll(races.produceRaceList().reversed.toList());
          if (loaded - 100 < 0) loaded = 0;
          else loaded -= 100;
          yield RaceListLoaded(items);
        } else {
          yield RaceListLoaded(items);
        }
      } on NetworkException {
        yield const RaceListError("Couldn't fetch raceList. Is the service online?");
      }
    }
    else if(event is GetSeason) {
      try {
        yield const RaceListLoading();
        final races = await _raceListRepository.fetchSeason(event.season);
        items = races.produceRaceList();
        season = true;
        loaded = 979;
        yield RaceListSeason(items.reversed.toList());
      } on NetworkException {
        yield const RaceListError("Couldn't fetch raceList. Is the service online?");
      }
    }
    else if(event is InitList) {
      yield const RaceListInitial();
          season =false;
          loaded = 979;
          items =[];
    }
  }

}