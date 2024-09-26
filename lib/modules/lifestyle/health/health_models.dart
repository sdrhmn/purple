import 'package:objectbox/objectbox.dart';

@Entity()
class HealthProject {
  @Id()
  int id;
  String condition; // One-line text field
  int criticality; // Rating between 1 and 5
  @Backlink()
  final healthTasks = ToMany<HealthTask>(); // Stores related tasks

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
  DateTime dateTime; // Date and time fields for task creation
  String task; // Next task (one-line text)
  String update; // Multi-line update text
  final healthProject = ToOne<HealthProject>(); // Link back to parent project

  HealthTask({
    this.id = 0,
    required this.dateTime,
    required this.task,
    required this.update,
  });
}
