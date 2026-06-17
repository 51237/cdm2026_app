class Team {
  final String name;
  final String flagIcon;
  final String fifaCode;
  final String continent;
  final String? group;
  final String confed;

  const Team({
    required this.name,
    required this.flagIcon,
    required this.fifaCode,
    required this.continent,
    required this.confed,
    this.group,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['name'] as String,
      flagIcon: json['flag_icon'] as String,
      fifaCode: json['fifa_code'] as String,
      continent: json['continent'] as String,
      confed: json['confed'] as String,
      group: json['group'] as String?,
    );
  }
}
