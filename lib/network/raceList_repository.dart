import 'dart:convert';

import 'package:f1calendarflutter/data/network/NetworkResonse.dart';
import 'package:http/http.dart' as http;

import '../data/model/model.dart';

abstract class RaceListRepository {
  Future<Response> fetchRaces(String from);
  Future<Response> fetchSeason(String season);
}

class ConcreteRaceListRepository implements RaceListRepository {


  @override
  Future<Response> fetchRaces(String from) async {
    final netRes = await http.get(Uri.parse('https://ergast.com/api/f1.json?limit=' + 100.toString() + '&offset=' + from));
    if(netRes.statusCode == 200) {
      return Response.fromJson(jsonDecode(netRes.body));
    }
    else {
      throw Exception('Failed to load race list');
    }
  }

  @override
  Future<Response> fetchSeason(String season) async{
    final netRes = await http.get(Uri.parse('https://ergast.com/api/f1/' + season + '.json'));
    if(netRes.statusCode == 200) {
      return Response.fromJson(jsonDecode(netRes.body));
    }
    else {
      throw Exception('Failed to load season');
    }
  }
}

class NetworkException implements Exception {}