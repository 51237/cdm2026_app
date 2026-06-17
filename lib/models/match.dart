class Goal {
  final String name;
  final String minute;

  const Goal({required this.name, required this.minute});

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      name: json['name'] as String,
      // la minute est parfois un int, parfois une string selon les entrées
      minute: json['minute'].toString(),
    );
  }
}

class Match {
  final int? num;
  final String round;
  final String date;
  final String time;
  final String team1;
  final String team2;
  final String? group;
  final String ground;
  final List<int>? scoreFt;
  final List<Goal> goals1;
  final List<Goal> goals2;

  const Match({
    this.num,
    required this.round,
    required this.date,
    required this.time,
    required this.team1,
    required this.team2,
    required this.ground,
    this.group,
    this.scoreFt,
    this.goals1 = const [],
    this.goals2 = const [],
  });

  bool get isUpcoming => scoreFt == null;

  factory Match.fromJson(Map<String, dynamic> json) {
    List<int>? ft;
    final score = json['score'];
    if (score != null && score['ft'] != null) {
      ft = List<int>.from(score['ft'] as List);
    }

    List<Goal> parseGoals(dynamic raw) {
      if (raw == null) return const [];
      return (raw as List)
          .map((g) => Goal.fromJson(g as Map<String, dynamic>))
          .toList();
    }

    return Match(
      num: json['num'] as int?,
      round: json['round'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      team1: json['team1'] as String,
      team2: json['team2'] as String,
      group: json['group'] as String?,
      ground: json['ground'] as String,
      scoreFt: ft,
      goals1: parseGoals(json['goals1']),
      goals2: parseGoals(json['goals2']),
    );
  }
}
