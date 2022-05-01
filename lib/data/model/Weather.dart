import 'package:f1calendarflutter/data/network/NetworkResonse.dart';

class Weather {
  final String cityName;
  final double temperatureCelsius;
  final List<String> names;
  final Response res;

  Weather({
    required this.cityName,
    required this.temperatureCelsius,
    required this.names,
    required this.res
  });

}