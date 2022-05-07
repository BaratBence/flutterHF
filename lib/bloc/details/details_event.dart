part of 'details_bloc.dart';

@immutable
abstract class DetailsEvent {}

class GetDetails extends DetailsEvent {

  GetDetails(this.season, this.round);

  final String season;
  final String round;
}