import 'dart:convert';

import '../data/network/NetworkResonse.dart';
import 'package:http/http.dart' as http;

abstract class DetailsRepository {
  Future<Response> fetchDetails(String season, String round);

  Future<Response> fetchResults(String season, String round);
}

class ConcreteDetailsRepository implements DetailsRepository {


  @override
  Future<Response> fetchDetails(String season, String round) async {
    final netRes = await http.get(Uri.parse('https://ergast.com/api/f1/' + season + '/' + round+'.json'));
    if(netRes.statusCode == 200) {
      return Response.fromJson(jsonDecode(netRes.body));
    }
    else {
      throw Exception('Failed to load details');
    }
  }

  @override
  Future<Response> fetchResults(String season, String round) async {
    final netRes = await http.get(Uri.parse('https://ergast.com/api/f1/' + season + '/' + round+'/results.json'));
    if(netRes.statusCode == 200) {
      return Response.fromJson(jsonDecode(netRes.body));
    }
    else {
      throw Exception('Failed to load results');
    }
  }
}

class NetworkException implements Exception {}