import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/match.dart';
import '../models/team.dart';

class WorldCupApi {
  static const String _matchesUrl =
      'https://raw.githubusercontent.com/openfootball/worldcup.json/master/2026/worldcup.json';

  static const String _teamsUrl =
      'https://raw.githubusercontent.com/openfootball/worldcup.json/master/2026/worldcup.teams.json';

  Future<List<Match>> fetchMatches() async {
    final response = await http.get(Uri.parse(_matchesUrl));

    if (response.statusCode != 200) {
      throw Exception('Echec du chargement (HTTP ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final matchesJson = data['matches'] as List;

    return matchesJson
        .map((m) => Match.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  Future<List<Team>> fetchTeams() async {
    final response = await http.get(Uri.parse(_teamsUrl));

    if (response.statusCode != 200) {
      throw Exception(
        'Echec du chargement des équipes (HTTP ${response.statusCode})',
      );
    }

    // Le fichier teams a une LISTE à la racine, pas un objet
    final data = jsonDecode(response.body) as List;
    return data.map((t) => Team.fromJson(t as Map<String, dynamic>)).toList();
  }
}
