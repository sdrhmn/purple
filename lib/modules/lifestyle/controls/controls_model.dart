import 'package:objectbox/objectbox.dart';

@Entity()
class ControlsModel {
  @Id()
  int id = 0;
  @Property(type: PropertyType.date)
  late DateTime date;
  late int communication;
  late int food;
  late int spending;
  // late String comments;
  List get values => [communication, food, spending];

  ControlsModel({
    required this.date,
    required this.communication,
    required this.food,
    required this.spending,
    // comments,
  }) {
    // this.comments = comments ?? "";
  }
}
