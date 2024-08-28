import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/modules/projects/project_model.dart';
import 'package:timely/modules/tasks/models/repetition_data_model.dart';

class Task {
  int? id;
  late int notifId;
  bool isComplete = false;
  DateTime? completedAt;
  String name;
  String description;
  DateTime? date;
  TimeOfDay? time;
  String type;
  String priority;
  Duration? duration;
  SchedulingModel? repeatRule;
  int? repetitionDataId;
  Map<int, Duration> reminders;
  List<Subtask> subtasks;

  Task({
    required this.name,
    required this.description,
    this.date,
    isComplete,
    this.completedAt,
    this.time,
    notifId,
    required this.type,
    required this.priority,
    this.duration,
    this.repeatRule,
    this.repetitionDataId,
    this.reminders = const {},
    this.subtasks = const [],
  }) {
    this.notifId = notifId ?? Random().nextInt(50e3.toInt());
    this.isComplete = isComplete ?? this.isComplete;
  }

  factory Task.empty() {
    return Task(
      name: "",
      description: "",
      type: "",
      priority: "high",
      reminders: {},
    );
  }

  factory Task.fromDataTask(DataTask dataTask) {
    Map json = jsonDecode(dataTask.data);

    return Task(
      name: json['name'] ?? json['activity'],
      description: json['description'] ?? "",
      notifId: json['notif_id'],
      isComplete: dataTask.completed,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: json['time'] != null
          ? TimeOfDay(hour: json['time'].first, minute: json['time'].last)
          : null,
      type: json['type'],
      priority: json['priority'],
      duration:
          json['duration'] != null ? Duration(seconds: json['duration']) : null,
      repeatRule: dataTask.repetitionData.target != null
          ? SchedulingModel.fromJson(
              jsonDecode(dataTask.repetitionData.target!.data))
          : null,
      repetitionDataId: dataTask.repetitionData.targetId != 0
          ? dataTask.repetitionData.targetId
          : null,
      reminders: (json['reminders'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(int.parse(key), Duration(seconds: value))),
      subtasks: jsonDecode(json['subtasks'] ?? '[]')
          .map((json) => Subtask.fromJson(json))
          .toList()
          .cast<Subtask>(),
    )..id = dataTask.id;
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'] ?? json['activity'],
      notifId: json['notif_id'],
      description: json['description'] ?? "",
      isComplete: json['is_complete'],
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: json['time'] != null
          ? TimeOfDay(hour: json['time'].first, minute: json['time'].last)
          : null,
      type: json['type'],
      priority: json['priority'],
      duration:
          json['duration'] != null ? Duration(seconds: json['duration']) : null,
      repeatRule: json['repeat_rule'] != null
          ? SchedulingModel.fromJson(json['repeat_rule'])
          : null,
      repetitionDataId: json['repetition_data_id'],
      reminders: (json['reminders'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(int.parse(key), Duration(seconds: value))),
      subtasks: jsonDecode(json['subtasks'] ?? '[]')
          .map((json) => Subtask.fromJson(json))
          .toList()
          .cast<Subtask>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'notif_id': notifId,
      'is_complete': isComplete,
      'completed_at': completedAt?.toIso8601String(),
      'date': date?.toIso8601String(),
      'time': time == null
          ? null
          : [
              time!.hour,
              time!.minute
            ], // You might need to define a method to convert TimeOfDay to a string
      'type': type,
      'priority': priority,
      'duration': duration?.inSeconds, // Or any other representation you prefer
      'reminders': reminders
          .map((key, value) => MapEntry(key.toString(), value.inSeconds)),
      'subtasks':
          jsonEncode(subtasks.map((subtask) => subtask.toJson()).toList()),
    };
  }

  // Creates a new Task object with updated properties.
  Task copyWith({
    String? name,
    DateTime? date,
    bool? isComplete,
    DateTime? completedAt,
    String? description,
    TimeOfDay? time,
    String? type,
    String? priority,
    Duration? duration,
    SchedulingModel? repeatRule,
    Map<int, Duration>? reminders,
    List<Subtask>? subtasks,
  }) {
    return Task(
      name: name ?? this.name,
      description: description ?? this.description,
      isComplete: isComplete ?? this.isComplete,
      completedAt: completedAt ?? this.completedAt,
      date: date ?? this.date,
      time: time ?? this.time,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      duration: duration ?? this.duration,
      repeatRule: repeatRule ?? this.repeatRule,
      reminders: reminders ?? this.reminders,
      subtasks: subtasks ?? this.subtasks,
    )..id = id;
  }

  // Creates a new Task object with specified fields nullified.
  Task nullify({
    bool duration = false,
    bool repeatRule = false,
    bool completedAt = false,
  }) {
    return Task(
      name: name,
      description: description,
      date: date,
      time: time,
      type: type,
      priority: priority,
      reminders: reminders,
      duration: duration ? null : this.duration,
      repeatRule: repeatRule ? null : this.repeatRule,
      repetitionDataId: repetitionDataId,
      isComplete: isComplete,
      completedAt: completedAt ? null : this.completedAt,
      notifId: notifId,
    )..id = id;
  }
}

class Subtask {
  String name;
  bool isComplete;

  Subtask({
    required this.name,
    this.isComplete = false,
  });

  toJson() {
    return {
      'name': name,
      'is_complete': isComplete,
    };
  }

  factory Subtask.fromJson(Map json) {
    return Subtask(
      name: json['name'],
      isComplete: json['is_complete'],
    );
  }
}

@Entity()
class DataTask {
  @Id(assignable: true)
  int id = 0;

  @Property(type: PropertyType.date)
  DateTime? dateTime;
  bool completed;
  String data;
  final repetitionData = ToOne<RepetitionData>();
  final project = ToOne<Project>();
  DataTask({
    this.id = 0,
    required this.dateTime,
    required this.data,
    this.completed = false,
  });
}
