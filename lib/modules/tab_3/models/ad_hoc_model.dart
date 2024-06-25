import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AdHocModel {
  String? uuid;
  late int? notifId;
  DateTime? date;
  TimeOfDay? startTime;
  String name = "";
  int priority = 0;
  bool notifOn = true;
  Map<int, Duration> reminders = {};

  AdHocModel({
    required this.name,
    required this.priority,
    this.uuid,
    this.date,
    this.startTime,
    notifId,
    reminders,
    required this.notifOn,
  }) {
    this.reminders = reminders ?? {};
    this.notifId = notifId ?? Random().nextInt(9000);
  }

  Map toJson() {
    if (startTime != null && date != null) {
      return {
        "ID": uuid ?? const Uuid().v4(),
        "Reminders": jsonEncode((reminders).map(
          (key, value) => MapEntry(key.toString(), value.inMinutes),
        )),
        "Notification ID": notifId,
        "Activity": name,
        "Time": "${startTime!.hour}: ${startTime!.minute}",
        "Priority": priority,
        "Notification ON": notifOn,
      };
    } else {
      return {
        "ID": uuid ?? const Uuid().v4(),
        "Activity": name,
        "Priority": priority,
        "Time": startTime != null
            ? "${startTime!.hour}: ${startTime!.minute}"
            : null,
        "Notification ID": date != null ? notifId : null,
        "Notification ON": date != null ? notifOn : null,
      };
    }
  }

  AdHocModel.fromJson(this.date, Map json) {
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

      startTime = time;
      this.name = name;
      this.priority = priority;
      notifOn = json["Notification ON"] ?? false;
    } else {
      notifId = json["Notification ID"];
      notifOn = json["Notification ON"] ?? false;

      String name = json["Activity"];
      int priority = json["Priority"];

      this.name = name;
      this.priority = priority;
    }
  }

  AdHocModel copyWith({
    DateTime? date,
    String? uuid,
    String? name,
    int? priority,
    TimeOfDay? time,
    bool? notifOn,
    Map<int, Duration>? reminders,
  }) {
    return AdHocModel(
      uuid: uuid ?? this.uuid,
      date: date ?? this.date,
      name: name ?? this.name,
      notifId: notifId,
      startTime: time ?? this.startTime,
      priority: priority ?? this.priority,
      notifOn: notifOn ?? this.notifOn,
      reminders: reminders ?? this.reminders,
    );
  }

  AdHocModel nullify({
    bool? date,
    bool? uuid,
    bool? name,
    bool? priority,
    bool? time,
    bool? notifOn,
    bool? reminders,
  }) {
    return AdHocModel(
      uuid: uuid == true ? null : this.uuid,
      date: date == true ? null : this.date,
      name: this.name,
      notifId: notifId,
      startTime: time == true ? null : startTime,
      priority: this.priority,
      notifOn: this.notifOn,
      reminders: reminders == true ? null : this.reminders,
    );
  }
}
