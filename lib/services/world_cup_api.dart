import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/match.dart';

class WorldCupApi {
  static const String _url =
      'https://raw.githubusercontent.com/openfootball/worldcup.json/master/2026/worldcup.json';

  Future<List<Match>> fetchMatches() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode != 200) {
      throw Exception('Echec du chargement (HTTP ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final matchesJson = data['matches'] as List;

    return matchesJson
        .map((m) => Match.fromJson(m as Map<String, dynamic>))
        .toList();
  }
}
