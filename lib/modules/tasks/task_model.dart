import 'package:flutter/material.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';

class Task {
  String activity;
  DateTime date;
  TimeOfDay time;
  String type;
  String difficulty;
  Duration? duration;
  SchedulingModel? repeatRule;
  Map<int, Duration> reminders;

  Task({
    required this.activity,
    required this.date,
    required this.time,
    required this.type,
    required this.difficulty,
    this.duration,
    this.repeatRule,
    required this.reminders,
  });

  factory Task.empty() {
    return Task(
      activity: "",
      date: DateTime.now(),
      time: TimeOfDay.now(),
      type: "",
      difficulty: "",
      reminders: {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity': activity,
      'date': date.toIso8601String(),
      'time':
          time, // You might need to define a method to convert TimeOfDay to a string
      'type': type,
      'difficulty': difficulty,
      'duration': duration?.inSeconds, // Or any other representation you prefer
      'repeatRule': repeatRule?.toJson(),
      'reminders': reminders
          .map((key, value) => MapEntry(key.toString(), value.inSeconds)),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      activity: json['activity'],
      date: DateTime.parse(json['date']),
      time: TimeOfDay(hour: json['time'].first, minute: json[['time'].last]),
      type: json['type'],
      difficulty: json['difficulty'],
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
    String? difficulty,
    Duration? duration,
    SchedulingModel? repeatRule,
    Map<int, Duration>? reminders,
  }) {
    return Task(
      activity: activity ?? this.activity,
      date: date ?? this.date,
      time: time ?? this.time,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
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
      difficulty: difficulty,
      reminders: reminders,
      duration: duration ? null : this.duration,
      repeatRule: repeatRule ? null : this.repeatRule,
    );
  }
}
