import 'package:f1calendarflutter/data/network/NetworkResonse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/model.dart';
import '../../network/details_repository.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final DetailsRepository _detailsRepository;

  DetailsBloc(this._detailsRepository): super(const DetailsInitial());

  @override
  Stream<DetailsState> mapEventToState(DetailsEvent event,) async* {
    if(event is GetDetails) {
      try {
        yield const DetailsLoading();
        final details = await _detailsRepository.fetchDetails(event.season, event.round);
        final results = await _detailsRepository.fetchResults(event.season, event.round);
        Race cDetail = details.produceDetails();
        Race cResult = results.produceDetails();
        cDetail.first = cResult.first;
        cDetail.second = cResult.second;
        cDetail.third = cResult.third;
        yield DetailsLoaded(cDetail);
      } on NetworkException {
        yield const RaceError("Couldn't fetch weather. Is the service online?");
      }
    }
  }

}