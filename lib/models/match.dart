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

  const Match({
    this.num,
    required this.round,
    required this.date,
    required this.time,
    required this.team1,
    required this.team2,
    this.group,
    required this.ground,
    this.scoreFt,
  });

  bool get isUpcoming => scoreFt == null;

  factory Match.fromJson(Map<String, dynamic> json) {
    List<int>? ft;
    final score = json['score'];
    if (score != null && score['ft'] != null) {
      ft = List<int>.from(score['ft'] as List);
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
    );
  }
}
