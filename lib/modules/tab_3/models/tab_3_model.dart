import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Tab3Model {
  String? uuid;
  DateTime? date;
  TimeOfDay? time;
  String text_1 = "";
  int priority = 0;

  Tab3Model({
    required this.text_1,
    required this.priority,
    this.uuid,
    this.date,
    this.time,
  });

  Map toJson() {
    if (time != null && date != null) {
      return {
        "ID": const Uuid().v4(),
        "Activity": text_1,
        "Time": "${time!.hour}: ${time!.minute}",
        "Priority": priority
      };
    } else {
      return {
        "ID": const Uuid().v4(),
        "Activity": text_1,
        "Priority": priority
      };
    }
  }

  Tab3Model.fromJson(this.date, Map json) {
    uuid = json["ID"];
    if (json["Time"] != null) {
      List timeParts = json["Time"].split(":");
      TimeOfDay time = TimeOfDay(
        hour: int.parse(timeParts.first),
        minute: int.parse(timeParts.last),
      );
      String text_1 = json["Activity"];
      int priority = json["Priority"];

      this.time = time;
      this.text_1 = text_1;
      this.priority = priority;
    } else {
      String text_1 = json["Activity"];
      int priority = json["Priority"];

      this.text_1 = text_1;
      this.priority = priority;
    }
  }

  Tab3Model copyWith(
      {DateTime? date,
      String? uuid,
      String? text_1,
      int? priority,
      TimeOfDay? time}) {
    return Tab3Model(
      uuid: uuid ?? this.uuid,
      date: date ?? this.date,
      text_1: text_1 ?? this.text_1,
      time: time ?? this.time,
      priority: priority ?? this.priority,
    );
  }
}
