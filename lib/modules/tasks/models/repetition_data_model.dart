import 'package:objectbox/objectbox.dart';

@Entity()
class RepetitionData {
  @Id()
  int id;
  String data;
  String task;

  RepetitionData({
    this.id = 0,
    required this.data,
    required this.task,
  });
}
