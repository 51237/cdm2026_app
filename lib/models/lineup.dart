// lib/models/lineup.dart

class Player {
  final int? number;
  final String name;
  final String position; // GK, DF, MF, FW
  final bool subbedOut;
  final bool subbedIn;
  final String? subbedOutMinute;
  final String? subbedInMinute;
  final List<String> yellowCard;
  final String? redCard;

  const Player({
    this.number,
    required this.name,
    required this.position,
    this.subbedOut = false,
    this.subbedIn = false,
    this.subbedOutMinute,
    this.subbedInMinute,
    this.yellowCard = const [],
    this.redCard,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      number: json['number'] as int?,
      name: json['name'] as String,
      position: json['position'] as String,
      subbedOut: json['subbedOut'] as bool? ?? false,
      subbedIn: json['subbedIn'] as bool? ?? false,
      subbedOutMinute: json['subbedOutMinute']?.toString(),
      subbedInMinute: json['subbedInMinute']?.toString(),
      yellowCard: (json['yellowCard'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      redCard: json['redCard']?.toString(),
    );
  }
}

class TeamLineup {
  final String formation; // e.g. "4-2-3-1"
  final List<Player> starting;
  final List<Player> bench;

  const TeamLineup({
    required this.formation,
    required this.starting,
    this.bench = const [],
  });

  factory TeamLineup.fromJson(Map<String, dynamic> json) {
    List<Player> parse(dynamic raw) => (raw as List? ?? [])
        .map((p) => Player.fromJson(p as Map<String, dynamic>))
        .toList();

    return TeamLineup(
      formation: json['formation'] as String,
      starting: parse(json['starting']),
      bench: parse(json['bench']),
    );
  }

  /// Splits the 11 starters into rows according to the formation digits.
  /// Returns rows ordered from goalkeeper outward: [ [GK], [DF...], ..., [FW...] ]
  List<List<Player>> get formationRows {
    final gk = starting.where((p) => p.position == 'GK').toList();
    final outfield = starting.where((p) => p.position != 'GK').toList();
    final counts = formation.split('-').map(int.parse).toList();

    final rows = <List<Player>>[gk];
    var idx = 0;
    for (final c in counts) {
      if (idx >= outfield.length) break;
      rows.add(outfield.sublist(idx, (idx + c).clamp(0, outfield.length)));
      idx += c;
    }
    if (idx < outfield.length) rows.add(outfield.sublist(idx));
    return rows;
  }
}

class MatchLineup {
  final TeamLineup team1;
  final TeamLineup team2;

  const MatchLineup({required this.team1, required this.team2});

  factory MatchLineup.fromJson(Map<String, dynamic> json) {
    return MatchLineup(
      team1: TeamLineup.fromJson(json['team1'] as Map<String, dynamic>),
      team2: TeamLineup.fromJson(json['team2'] as Map<String, dynamic>),
    );
  }
}