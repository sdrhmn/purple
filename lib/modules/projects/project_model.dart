import 'package:objectbox/objectbox.dart';
import 'package:timely/modules/tasks/models/task_model.dart';

@Entity()
class Project {
  @Id()
  int id = 0;
  String name;
  String description;
  String duration;
  @Backlink('project')
  final tasks = ToMany<DataTask>();

  Project({
    required this.name,
    required this.description,
    required this.duration,
  });
}
