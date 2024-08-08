import 'package:objectbox/objectbox.dart';

@Entity()
class RepetitionData {
  @Id()
  int id = 0;
  String data;
  String task;

  RepetitionData({
    id,
    required this.data,
    required this.task,
  }) {
    this.id = id ?? 0;
  }
}
