// lib/services/lineup_service.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/lineup.dart';
import '../models/match.dart';

class LineupService {
  Map<String, dynamic>? _raw;

  Future<void> load() async {
    if (_raw != null) return;
    final text = await rootBundle.loadString('assets/lineups.json');
    _raw = jsonDecode(text) as Map<String, dynamic>;
  }

  String _keyFor(Match m) => '${m.date}|${m.team1}|${m.team2}';

  bool hasLineup(Match m) => _raw != null && _raw!.containsKey(_keyFor(m));

  MatchLineup? lineupFor(Match m) {
    if (_raw == null) return null;
    final entry = _raw![_keyFor(m)];
    if (entry == null) return null;
    return MatchLineup.fromJson(entry as Map<String, dynamic>);
  }
}