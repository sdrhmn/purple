import 'dart:convert';
import 'package:objectbox/objectbox.dart';

enum ExercisePurpose {
  evaluation,
  workout,
}

@Entity()
class Exercise {
  @Id()
  int id = 0;

  // Purpose as an enum with custom converter
  @Transient()
  ExercisePurpose purpose;

  int get dbPurpose => purpose.index;

  set dbPurpose(int value) {
    purpose = ExercisePurpose.values[value];
  }

  // Custom converter for List<List> data
  @Transient()
  List<List<dynamic>> data = [[]];

  String get dbData => jsonEncode(data);

  set dbData(String value) {
    data =
        (jsonDecode(value) as List).map((e) => List<dynamic>.from(e)).toList();
  }

  @Property(type: PropertyType.date)
  DateTime date;

  // Time stored as DateTime but representing only time
  @Property(type: PropertyType.date)
  DateTime time;

  // Duration stored as total seconds
  @Transient()
  Duration duration;

  int get durationSeconds => duration.inSeconds;

  set durationSeconds(int value) {
    duration = Duration(seconds: value);
  }

  // rrule string for recurrence
  String repeats;

  final dataRepeatExercise = ToOne<DataRepeatExercise>();

  Exercise({
    this.purpose = ExercisePurpose.evaluation,
    data,
    required this.date,
    required this.time,
    this.duration = Duration.zero,
    this.repeats = '',
  }) {
    this.data = data ?? [[]];
  }

  // Converts the object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purpose': purpose.index,
      'data': data,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'duration': duration.inSeconds,
      'repeats': repeats,
    };
  }

  // New fromJson method
  static Exercise fromJson(Map<String, dynamic> json) {
    return Exercise(
      purpose: ExercisePurpose.values[json['purpose'] as int],
      data: (json['data'] as List).map((e) => List<dynamic>.from(e)).toList(),
      date: DateTime.parse(json['date']),
      time: DateTime.parse(json['time']),
      duration: Duration(seconds: json['duration'] as int),
      repeats: json['repeats'] as String,
    )
      ..id = json['id'] as int
      ..dbPurpose = json['purpose'] as int
      ..dbData = jsonEncode(json['data']);
  }
}

@Entity()
class DataRepeatExercise {
  @Id()
  int id = 0;

  @Property()
  String data;

  DataRepeatExercise({this.data = ''});
}
