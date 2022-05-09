part of 'raceList_bloc.dart';


@immutable
abstract class RaceListEvent {}

class GetRaces extends RaceListEvent {

  GetRaces(this.from);
  final String from;
}

class GetSeason extends RaceListEvent {
  GetSeason(this.season);

  final String season;
}

class ViewCreated extends RaceListEvent {
  ViewCreated();
}