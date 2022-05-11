part of 'details_bloc.dart';

abstract class DetailsState {
  const DetailsState();
}

class DetailsInitial extends DetailsState {
  const DetailsInitial();
}

class DetailsLoading extends DetailsState {
  const DetailsLoading();
}

class DetailsLoaded extends DetailsState {
  final Race race;
  const DetailsLoaded(this.race);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DetailsLoaded && o.race == race;
  }

  @override
  int get hashCode => race.hashCode;
}

class RaceError extends DetailsState {
  final String message;
  const RaceError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RaceError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}