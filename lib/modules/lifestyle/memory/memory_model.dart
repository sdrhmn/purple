import 'package:objectbox/objectbox.dart';

@Entity()
class MemoryModel {
  @Id()
  int id = 0;
  String title;
  String detail;
  String type;
  int importance;

  MemoryModel({
    required this.title,
    required this.detail,
    required this.type,
    required this.importance,
  });
}
