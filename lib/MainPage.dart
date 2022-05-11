
import 'package:f1calendarflutter/bloc/race/raceList_bloc.dart';
import 'package:f1calendarflutter/data/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'DetailsView.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late RaceListBloc racesBloc;
  late ScrollController scrollController;


  double listEnd = 0;
  bool initiated = false;

  @override
  void initState() {
    racesBloc = BlocProvider.of<RaceListBloc>(context);
    racesBloc.add(GetRaces());

    super.initState();
  }

  ScrollController initializeScroller(double listPosition) {
    scrollController = ScrollController(initialScrollOffset: listPosition, keepScrollOffset: true,);
    scrollController.addListener(() {
      if(scrollController.hasClients) {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && racesBloc.state is! RaceListSeason) {
          racesBloc.add(GetRaces());
        }
      }
    });
    return scrollController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Card(
            elevation: 20,
            color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const SizedBox(
              child: Center(
                  child: Text('Races', style: TextStyle(fontSize: 40, color: Colors.white))),
            )),
        const SeasonInputField(),
        BlocConsumer<RaceListBloc, RaceListState>(
          listener: (context, state) {
            if (state is RaceListError) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
              ));
            }
          },
          builder: (context, state) {
            if (state is RaceListLoading) {
              return buildLoading();
            } else if (state is RaceListLoaded) {
              initiated = false;
              scrollController = initializeScroller(listEnd);
              return buildLoaded(state.races);
            } else if (state is RaceListSeason) {
              listEnd = 0;
              scrollController = initializeScroller(listEnd);
              return buildLoaded(state.races);
            } else {
              return buildLoading();
            }
          },
        ),
      ]),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildLoaded(List<RaceListItem> races) {
    return raceListView(races);
  }

  void updateListEnd(){
    listEnd = scrollController.position.maxScrollExtent;
  }
  

  Widget raceListView(List<RaceListItem> races) {
    Widget view = Flexible(
        child: ListView.builder(
            padding: const EdgeInsets.all(0),
            controller: scrollController,
            itemCount: races.length,
            itemBuilder: (BuildContext context, int index) {
              SchedulerBinding.instance?.addPostFrameCallback((_) {
                if(!initiated) {
                  updateListEnd();
                  initiated = true;
                }
              });
              return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Card(
                      child: SizedBox(
                      height: 50,
                      child: Table(
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1: FixedColumnWidth(100)
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(children: <Widget>[
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(races[index].name))),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: MaterialButton(
                              height: 30.0,
                              minWidth: 30.0,
                              color: Colors.red,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsView(
                                          season: races[index].season,
                                          round: races[index].round)),
                                );
                              },
                              child: const Text("Details"),
                            ),
                          ))
                        ])
                      ],
                    ),
                  )));
            }));
    return view;
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
}

class SeasonInputField extends StatelessWidget {
  const SeasonInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: TextField(
          onSubmitted: (value) => submitSeason(context, value),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              hintText: "Enter Season",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: const Icon(Icons.search)),
        ));
  }

  void submitSeason(BuildContext context, String season) {
    int seasonInt = 0;
    if (season.isEmpty) {
      final racesBloc = BlocProvider.of<RaceListBloc>(context);
      racesBloc.add(GetRaces());
    } else {
      try {
        seasonInt = int.parse(season);
      } on FormatException {
        Fluttertoast.showToast(
            msg: "Please add a number between 1950 and 2022",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (seasonInt >= 1950 && seasonInt <= 2022) {
        final racesBloc = BlocProvider.of<RaceListBloc>(context);
        racesBloc.add(GetSeason(seasonInt.toString()));
      } else {
        Fluttertoast.showToast(
            msg: "Please add a number between 1950 and 2022",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
