
class RaceListItem {
  late String name;
  late String season;
  late String round;

  RaceListItem({required this.name, required this.season, required this.round});
}

class Race {
  late String ID;
  late String locality;
  late String raceName;
  late String circuitName;
  late String eventID;
  String first = "TBD";
  String second = "TBD";
  String third = "TBD";
  List<Session> sessions = [];

  Race({
  required this.ID,
  required this.locality,
  required this.raceName,
  required this.circuitName,
  required this.eventID,
  required this.first,
  required this.second,
  required this.third,
  required this.sessions
  });
}


class Session {
  late String name;
  late String date;
  late String time;

  Session({required this.name, required this.date, required this.time});
}