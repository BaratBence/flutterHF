import 'package:f1calendarflutter/MainPage.dart';
import 'package:f1calendarflutter/network/details_repository.dart';
import 'package:f1calendarflutter/network/raceList_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/details/details_bloc.dart';
import 'bloc/race/raceList_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
      title: 'F1 Calendar',
      home: BlocProvider(
        create: (context) => WeatherBloc(FakeWeatherRepository()),
        child: MainPage()
      ),
  */
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => RaceListBloc(ConcreteRaceListRepository())),
          BlocProvider(create: (context) => DetailsBloc(ConcreteDetailsRepository())),
        ],
        child: MaterialApp(
          title: 'F1 Calendar',
          home: MainPage()
      )
    );
  }
}