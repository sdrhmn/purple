import 'package:objectbox/objectbox.dart';

@Entity()
class DiaryModel {
  @Id()
  int id = 0;
  @Property(type: PropertyType.date)
  DateTime date;
  String place;
  String title;
  String description;
  String type;
  int importance;

  DiaryModel({
    required this.date,
    required this.place,
    required this.title,
    required this.description,
    required this.type,
    required this.importance,
  });
}
