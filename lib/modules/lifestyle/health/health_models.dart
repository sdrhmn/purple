import 'package:objectbox/objectbox.dart';

@Entity()
class HealthProject {
  @Id()
  int id;
  String condition;
  int criticality;
  @Backlink()
  final healthTasks = ToMany<HealthTask>();

  HealthProject({
    this.id = 0,
    required this.condition,
    required this.criticality,
  });
}

@Entity()
class HealthTask {
  @Id()
  int id;
  @Property(type: PropertyType.date)
  DateTime dateTime;
  String task;
  String update;
  final healthProject = ToOne<HealthProject>();

  HealthTask({
    this.id = 0,
    required this.dateTime,
    required this.task,
    required this.update,
  });
}
