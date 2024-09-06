import 'package:objectbox/objectbox.dart';
import 'package:timely/modules/tasks/models/task_model.dart';

@Entity()
class Project {
  @Id()
  int id = 0;

  String name;
  String description;

  @Transient()
  Duration duration;

  String get dbDuration => "${duration.inDays}:${duration.inHours}";

  set dbDuration(String value) {
    List vals = value.split(":").map((val) => int.parse(val)).toList();
    duration = Duration(days: vals.first, hours: vals.last);
  }

  @Backlink('project')
  final tasks = ToMany<DataTask>();

  Project({
    required this.name,
    required this.description,
    this.duration = Duration.zero,
  });
}
