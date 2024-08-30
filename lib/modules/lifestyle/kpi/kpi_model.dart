import 'package:objectbox/objectbox.dart';

@Entity()
class KPIModel {
  @Id()
  int id = 0;
  @Property(type: PropertyType.date)
  late DateTime date;
  late int activity;
  late int sleep;
  late int bowelMovement;
  late double weight;
  late String comments;
  List get values => [activity, sleep, bowelMovement, weight];

  KPIModel({
    required this.date,
    required this.activity,
    required this.sleep,
    required this.bowelMovement,
    required this.weight,
    comments,
  }) {
    this.comments = comments ?? "";
  }
}
