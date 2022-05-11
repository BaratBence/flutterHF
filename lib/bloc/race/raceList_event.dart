part of 'raceList_bloc.dart';


@immutable
abstract class RaceListEvent {}

class GetRaces extends RaceListEvent {

  GetRaces();
}

class GetSeason extends RaceListEvent {
  GetSeason(this.season);

  final String season;
}