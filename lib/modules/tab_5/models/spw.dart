class SPWModel {
  late DateTime date;
  late int sScore;
  late int pScore;
  late int wScore;
  late double? weight;

  SPWModel(
      {required this.date,
      required this.sScore,
      required this.pScore,
      required this.wScore,
      this.weight});

  SPWModel.fromJson(Map json) {
    date = DateTime.parse(json.keys.toList()[0]);
    List spw = json.values.toList()[0];
    double weight = json.values.toList()[1];
    int accum = 0;
    for (var _ in [sScore, pScore, wScore]) {
      _ = spw[accum];
      accum += 1;
    }
    this.weight = weight;
  }

  Map toJson() {
    return {
      date.toString().substring(0, 10): [
        [sScore, pScore, wScore],
        weight
      ]
    };
  }

  SPWModel copyWith({date, sScore, pScore, wScore, weight}) {
    return SPWModel(
      date: date ?? this.date,
      sScore: sScore ?? this.sScore,
      pScore: pScore ?? this.pScore,
      wScore: wScore ?? this.wScore,
      weight: weight ?? this.weight,
    );
  }
}
// TODO inshaa Allah :: Implement this class

