import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';

class Task {
  int id = 0;
  late int notifId;
  bool isComplete = false;
  String activity;
  DateTime? date;
  TimeOfDay? time;
  String type;
  String priority;
  Duration? duration;
  SchedulingModel? repeatRule;
  Map<int, Duration> reminders;

  Task({
    required this.activity,
    this.date,
    isComplete,
    this.time,
    notifId,
    required this.type,
    required this.priority,
    this.duration,
    this.repeatRule,
    this.reminders = const {},
  }) {
    this.notifId = notifId ?? Random().nextInt(50e3.toInt());
    this.isComplete = isComplete ?? this.isComplete;
  }

  factory Task.empty() {
    return Task(
      activity: "",
      type: "ad-hoc",
      priority: "low",
      reminders: {},
    );
  }

  factory Task.fromDataTask(DataTask dataTask) {
    Map json = jsonDecode(dataTask.data);

    return Task(
      activity: json['activity'],
      notifId: json['notif_id'],
      isComplete: dataTask.completed,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: json['time'] != null
          ? TimeOfDay(hour: json['time'].first, minute: json['time'].last)
          : null,
      type: json['type'],
      priority: json['priority'],
      duration:
          json['duration'] != null ? Duration(seconds: json['duration']) : null,
      repeatRule: json['repeatRule'] != null
          ? SchedulingModel.fromJson(json['repeatRule'])
          : null,
      reminders: (json['reminders'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(int.parse(key), Duration(seconds: value))),
    )..id = dataTask.id;
  }

  Map<String, dynamic> toJson() {
    return {
      'activity': activity,
      'notif_id': notifId,
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
      'repeatRule': repeatRule?.toJson(),
      'reminders': reminders
          .map((key, value) => MapEntry(key.toString(), value.inSeconds)),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      activity: json['activity'],
      notifId: json['notif_id'],
      isComplete: json['is_complete'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: json['time'] != null
          ? TimeOfDay(hour: json['time'].first, minute: json['time'].last)
          : null,
      type: json['type'],
      priority: json['priority'],
      duration:
          json['duration'] != null ? Duration(seconds: json['duration']) : null,
      repeatRule: json['repeatRule'] != null
          ? SchedulingModel.fromJson(json['repeatRule'])
          : null,
      reminders: (json['reminders'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(int.parse(key), Duration(seconds: value))),
    );
  }

  // Creates a new Task object with updated properties.
  Task copyWith({
    String? activity,
    DateTime? date,
    TimeOfDay? time,
    String? type,
    String? priority,
    Duration? duration,
    SchedulingModel? repeatRule,
    Map<int, Duration>? reminders,
  }) {
    return Task(
      activity: activity ?? this.activity,
      date: date ?? this.date,
      time: time ?? this.time,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      duration: duration ?? this.duration,
      repeatRule: repeatRule ?? this.repeatRule,
      reminders: reminders ?? this.reminders,
    );
  }

  // Creates a new Task object with specified fields nullified.
  Task nullify({
    bool duration = false,
    bool repeatRule = false,
  }) {
    return Task(
      activity: activity,
      date: date,
      time: time,
      type: type,
      priority: priority,
      reminders: reminders,
      duration: duration ? null : this.duration,
      repeatRule: repeatRule ? null : this.repeatRule,
    );
  }
}

@Entity()
class DataTask {
  @Id(assignable: true)
  int id = 0;

  @Property(type: PropertyType.date)
  DateTime date;
  bool completed;
  String data;

  DataTask({
    this.id = 0,
    required this.date,
    required this.data,
    this.completed = false,
  });
}
