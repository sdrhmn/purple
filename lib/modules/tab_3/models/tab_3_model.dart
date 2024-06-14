import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Tab3Model {
  String? uuid;
  late int? notifId;
  DateTime? date;
  TimeOfDay? time;
  String name = "";
  int priority = 0;
  bool notifOn = true;
  Map<int, Duration> reminders = {};

  Tab3Model({
    required this.name,
    required this.priority,
    this.uuid,
    this.date,
    this.time,
    notifId,
    reminders,
    required this.notifOn,
  }) {
    this.reminders = reminders ?? {};
    this.notifId = notifId ?? Random().nextInt(9000);
  }

  Map toJson() {
    if (time != null && date != null) {
      return {
        "ID": uuid ?? const Uuid().v4(),
        "Reminders": jsonEncode((reminders).map(
          (key, value) => MapEntry(key.toString(), value.inMinutes),
        )),
        "Notification ID": notifId,
        "Activity": name,
        "Time": "${time!.hour}: ${time!.minute}",
        "Priority": priority,
        "Notification ON": notifOn,
      };
    } else {
      return {
        "ID": uuid ?? const Uuid().v4(),
        "Activity": name,
        "Priority": priority,
      };
    }
  }

  Tab3Model.fromJson(this.date, Map json) {
    uuid = json["ID"].toString();
    if (json["Time"] != null) {
      var rems = jsonDecode(json["Reminders"]) != {}
          ? jsonDecode(json["Reminders"]).map((key, value) =>
              MapEntry(int.parse(key), Duration(minutes: value)))
          : {};
      reminders = Map<int, Duration>.from(rems);

      notifId = json["Notification ID"];
      List timeParts = json["Time"].split(":");

      TimeOfDay time = TimeOfDay(
        hour: int.parse(timeParts.first),
        minute: int.parse(timeParts.last),
      );
      String name = json["Activity"];
      int priority = json["Priority"];

      this.time = time;
      this.name = name;
      this.priority = priority;
      notifOn = json["Notification ON"] ?? false;
    } else {
      String name = json["Activity"];
      int priority = json["Priority"];

      this.name = name;
      this.priority = priority;
    }
  }

  Tab3Model copyWith({
    DateTime? date,
    String? uuid,
    String? name,
    int? priority,
    TimeOfDay? time,
    bool? notifOn,
    Map<int, Duration>? reminders,
  }) {
    return Tab3Model(
      uuid: uuid ?? this.uuid,
      date: date ?? this.date,
      name: name ?? this.name,
      notifId: notifId,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      notifOn: notifOn ?? this.notifOn,
      reminders: reminders ?? this.reminders,
    );
  }
}
