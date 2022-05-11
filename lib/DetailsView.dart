import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/details/details_bloc.dart';
import 'data/model/model.dart';
import 'package:flutter/services.dart' show rootBundle;

class DetailsView extends StatefulWidget {
  const DetailsView({Key? key, required this.season, required this.round})
      : super(key: key);

  final String season;
  final String round;

  @override
  State<StatefulWidget> createState() =>
      _DetailsViewState(season: season, round: round);
}

class _DetailsViewState extends State<DetailsView> {
  _DetailsViewState({required this.season, required this.round});

  final String season;
  final String round;

  @override
  void initState() {
    final weatherBloc = BlocProvider.of<DetailsBloc>(context);
    weatherBloc.add(GetDetails(season, round));
    super.initState();
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/config.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      BlocConsumer<DetailsBloc, DetailsState>(
        listener: (context, state) {
          if (state is RaceError) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
        },
        builder: (context, state) {
          if (state is DetailsInitial) {
            return buildInitialInput();
          } else if (state is DetailsLoading) {
            return buildLoading();
          } else if (state is DetailsLoaded) {
            return buildLoaded(state.race);
          } else {
            return buildInitialInput();
          }
        },
      ),
    ]));
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildInitialInput() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildLoaded(Race race) {
    return Column(children: <Widget>[
      Card(
          elevation: 20,
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Center(
                  child: Text(race.locality,
                      style: const TextStyle(fontSize: 25))),
            ),
          )),
      Card(
          elevation: 20,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Center(
                  child: Text(race.raceName,
                      style: const TextStyle(fontSize: 20))),
            ),
          )),
      Card(
          elevation: 20,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Center(
                  child: Text(race.circuitName,
                      style: const TextStyle(fontSize: 15))),
            ),
          )),
      Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                  child:
                      Text(race.eventID, style: const TextStyle(fontSize: 15))),
            )),
      ),
      Card(
          elevation: 20,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0),
              itemCount: race.sessions.length,
              itemBuilder: (BuildContext context, int index) {
                return Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(50),
                    1: FixedColumnWidth(125),
                    2: FixedColumnWidth(175)
                  },
                  //defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(children: <Widget>[
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, bottom: 10.0),
                        child: Text(race.sessions[index].date),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, bottom: 10.0),
                        child: Text(race.sessions[index].name),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, bottom: 10.0),
                        child: Text(race.sessions[index].time),
                      ))
                    ])
                  ],
                );
              })),
      Card(
          elevation: 20,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              const TableRow(children: <Widget>[
                TableCell(
                    child: Image(image: ResizeImage(AssetImage('lib/assets/silver.png'), width: 80, height: 115))),
                TableCell(
                        child: Image(image: ResizeImage(AssetImage('lib/assets/gold.png'), width: 80, height: 115))),
                TableCell(
                        child: Image(image: ResizeImage(AssetImage('lib/assets/bronze.png'), width: 80, height: 115)))
              ]),
              TableRow(children: <Widget>[
                TableCell(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Center(child: Text(race.second, style: const TextStyle(fontSize: 15))),
                )),
                TableCell(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Center(child: Text(race.first, style: const TextStyle(fontSize: 15))),
                )),
                TableCell(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Center(child: Text(race.third, style: const TextStyle(fontSize: 15))),
                ))
              ])
            ],
          ))
    ]);
  }
}
