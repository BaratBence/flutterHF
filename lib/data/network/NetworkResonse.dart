import 'package:f1calendarflutter/data/model/model.dart';

class Response {
  late MRData mRData;

  Response({required this.mRData});

  Response.fromJson(Map<String, dynamic> json) {
    mRData = MRData.fromJson(json['MRData']);
  }

  List<RaceListItem> produceRaceList() {
    List<RaceListItem> resultList = [];
    mRData.raceTable;
    for(var race in mRData.raceTable.races) {
      resultList.add(RaceListItem(name: race.season + " " + race.raceName,season: race.season,round: race.round));
    }
    return resultList;
  }

  Race produceDetails() {
    if(mRData.raceTable.races.isNotEmpty) {
      Races race = mRData.raceTable.races[0];
      String first = "TBD", second = "TBD", third = "TBD";
      if(race.results.isNotEmpty) {
        first = race.results[0].driver.produceDriver();
        second = race.results[1].driver.produceDriver();
        third = race.results[2].driver.produceDriver();
      }
      return Race(
            ID: race.season + " " + race.raceName,
            locality: race.circuit.location.locality,
            raceName: race.raceName,
            circuitName: race.circuit.circuitName,
            eventID: race.season.toString() + " season round " + race.round.toString() + " " + race.date!.substring(race.date!.length-2,race.date!.length),
            first: first,
            second: second,
            third: third,
            sessions: race.produceSession()
        );
    }
    else {
      return Race(
      ID: "0",
      locality: "NoWhere",
      raceName: "NoName",
      circuitName: "NoCircuit",
      eventID:  "NoID",
      first: "TBD",
      second: "TBD",
      third: "TBD",
      sessions: [],
    );
    }
  }
}

class MRData {
  late RaceTable raceTable;

  MRData({required this.raceTable});

  MRData.fromJson(Map<String, dynamic> json) {
    raceTable = RaceTable.fromJson(json['RaceTable']);
  }
}

class RaceTable {
  List<Races> races = [];

  RaceTable({required this.races});

  RaceTable.fromJson(Map<String, dynamic> json) {
      races = <Races>[];
      json['Races'].forEach((v) {
        races.add(Races.fromJson(v));
      });
  }
}

//TODO:
class Races {
  late String season;
  late String round;
  late String raceName;
  late Circuit circuit;
  late String? date;
  late String? time;
  Sessions? FirstPractice;
  Sessions? SecondPractice;
  Sessions? ThirdPractice;
  Sessions? Qualifying;
  Sessions? Sprint;
  List<Results> results = [];

  Races(
      {required this.season,
        required this.round,
        required this.raceName,
        required this.circuit,
        this.date,
        this.time,
        this.FirstPractice,
        this.SecondPractice,
        this.ThirdPractice,
        this.Qualifying});

  Races.fromJson(Map<String, dynamic> json) {
    season = json['season'];
    round = json['round'];
    raceName = json['raceName'];
    circuit = Circuit.fromJson(json['Circuit']);
    date = json['date'];
    time = json['time'];
    FirstPractice = json['FirstPractice'] != null ? Sessions.fromJson(json['FirstPractice']) : null;
    SecondPractice = json['SecondPractice'] != null ? Sessions.fromJson(json['SecondPractice']) : null;
    ThirdPractice = json['ThirdPractice'] != null ? Sessions.fromJson(json['ThirdPractice']) : null;
    Qualifying = json['Qualifying'] != null ? Sessions.fromJson(json['Qualifying']) : null;
    Sprint = json['Sprint'] != null ? Sessions.fromJson(json['Sprint']) : null;
    if (json['Results'] != null) {
      results = <Results>[];
      json['Results'].forEach((v) {
        results.add(Results.fromJson(v));
      });
    }
  }

  List<Session> produceSession() {
    List<Session> resultList = [];
    if(FirstPractice?.time == null) {
      resultList.add(Session(name: "Race", date: "",time:  "NO DATA"));
      resultList.add(Session(name: "Qualifying", date: "", time: "NO DATA"));
      resultList.add(Session(name: "Practice 3", date: "", time:"NO DATA"));
      resultList.add(Session(name: "Practice 2", date: "", time: "NO DATA"));
      resultList.add(Session(name:"Practice 1",date:  "", time: "NO DATA"));
      return resultList;
    }

    resultList.add(Session(name: "Race", date: date!.substring(date!.length-2, date!.length), time: "now"));
    resultList.add(Session(name: "Qualifying", date: Qualifying!.date!.substring(Qualifying!.date!.length-2, Qualifying!.date!.length), time: Qualifying!.createSessionTime(1)));
    if(ThirdPractice?.time == null) {
      resultList.add(Session(name: "Sprint", date: Sprint!.date!.substring(Sprint!.date!.length-2, Sprint!.date!.length), time: Sprint!.createSessionTime(2)));
    } else {
      resultList.add(Session(name: "Practice 3", date: ThirdPractice!.date!.substring(ThirdPractice!.date!.length-2, ThirdPractice!.date!.length),time: ThirdPractice!.createSessionTime(2)));
    }
    resultList.add(Session(name: "Practice 2", date : SecondPractice!.date!.substring(SecondPractice!.date!.length-2, SecondPractice!.date!.length), time :SecondPractice!.createSessionTime(2)));
    resultList.add(Session(name: "Practice 1", date: FirstPractice!.date!.substring(FirstPractice!.date!.length-2, FirstPractice!.date!.length), time: FirstPractice!.createSessionTime(2)));
    return resultList;
  }
}

class Circuit {
  late String circuitName;
  late Location location;

  Circuit({required this.circuitName, required this.location});

  Circuit.fromJson(Map<String, dynamic> json) {
    circuitName = json['circuitName'];
    location = Location.fromJson(json['Location']);
  }
}

class Location {
  late String locality;

  Location({required this.locality});

  Location.fromJson(Map<String, dynamic> json) {
    locality = json['locality'];
  }
}

class Results {
  late Driver driver;

  Results({required this.driver});

  Results.fromJson(Map<String, dynamic> json) {
    driver = Driver.fromJson(json['Driver']);
  }
}

class Driver {
  String? code;
  late String familyName;

  Driver({this.code, required this.familyName});

  Driver.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    familyName = json['familyName'];
  }

  String produceDriver() {
    if(code == null) {
      return familyName.substring(0,3).toUpperCase();
    } else {
      return code!;
    }
  }
}

class Sessions {
  String? date;
  String? time;

  Sessions({required this.date, this.time});

  Sessions.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
  }

  String createSessionTime(int length) {
    return time!.substring(0,2) + ":00-" + (int.parse(time!.substring(0,2))+2).toString() + ":00";
  }
}