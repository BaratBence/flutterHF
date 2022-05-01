import 'dart:convert';


import 'package:f1calendarflutter/data/model/Weather.dart';
import 'package:f1calendarflutter/data/network/NetworkResonse.dart';
import 'package:http/http.dart' as http;

abstract class WeatherRepository {
  Future<Weather> fetchWeather(String cityName);
}

class FakeWeatherRepository implements WeatherRepository {
  @override
  Future<Weather> fetchWeather(String cityName) async {
    final netRes = await http.get(Uri.parse('https://ergast.com/api/f1/2022/4.json'));
    if(netRes.statusCode == 200) {
      Response test = Response.fromJson(jsonDecode(netRes.body));
      //print(test.produceRaceList()[0].name);
      print(test.produceDetails().sessions[3].name);
      return Weather(
          cityName: cityName,
          // Temperature between 20 and 35.99
          temperatureCelsius: 10,
          names: ["Tibor" , "Bence" , "Zoli", "Dénes"],
          res: Response.fromJson(jsonDecode(netRes.body))
      );
    }
    else {
      throw Exception('Failed to load album');
    }
  }
}

class NetworkException implements Exception {}