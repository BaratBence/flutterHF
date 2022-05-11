part of 'raceList_bloc.dart';

abstract class RaceListState {
  const RaceListState();
}

class RaceListInitial extends RaceListState {
  const RaceListInitial();
}

class RaceListLoading extends RaceListState {
  const RaceListLoading();
}

class RaceListSeason extends RaceListState {
  final List<RaceListItem> races;
  const RaceListSeason(this.races);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RaceListLoaded && o.races == races;
  }

  @override
  int get hashCode => races.hashCode;
}

class RaceListLoaded extends RaceListState {
  final List<RaceListItem> races;
  const RaceListLoaded(this.races);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RaceListLoaded && o.races == races;
  }

  @override
  int get hashCode => races.hashCode;
}

class RaceListError extends RaceListState {
  final String message;
  const RaceListError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RaceListError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}