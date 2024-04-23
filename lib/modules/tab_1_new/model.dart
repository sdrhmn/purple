class Progress {
  late final List<int> hours;
  late final int points;
  late final int level;
  late final Map<String, DateTime> paused;
  late final List<String> stopped;

  Progress({
    required this.hours,
    required this.points,
    required this.level,
    required this.paused,
    required this.stopped,
  });

  Progress copyWith({
    List<int>? hours,
    int? points,
    int? level,
    Map<String, DateTime>? paused,
    List<String>? stopped,
  }) {
    return Progress(
      hours: hours ?? this.hours,
      points: points ?? this.points,
      level: level ?? this.level,
      paused: paused ?? this.paused,
      stopped: stopped ?? this.stopped,
    );
  }

  toJson() {
    // ignore: no_leading_underscores_for_local_identifiers
    Map<String, String> _paused = {};

    for (String letter in paused.keys) {
      _paused.addAll({letter: paused[letter]!.toIso8601String()});
    }

    return {
      'hours': hours,
      'points': points,
      'level': level,
      'paused': _paused,
      'stopped': stopped,
    };
  }

  Progress.fromJson(json) {
    // ignore: no_leading_underscores_for_local_identifiers
    Map<String, DateTime> _paused = {};

    for (String letter in json['paused'].keys) {
      _paused.addAll({letter: DateTime.parse(json['paused'][letter])});
    }

    hours = json['hours'].cast<int>();
    points = json['points'];
    level = json['level'];
    paused = _paused;
    stopped = json['stopped'].cast<String>();
  }

  @override
  String toString() {
    return 'Progress(hours: $hours, points: $points, level: $level, paused: $paused, stopped: $stopped)';
  }
}
