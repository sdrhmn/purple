import 'package:flutter/material.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/modules/tab_3/models/ad_hoc_model.dart';

class TaskToday {
  late final String name;
  late final TimeOfDay startTime;
  TimeOfDay? endTime;
  late final int tabNumber;
  late final dynamic model;

  TaskToday({
    required name,
    required startTime,
    required tabNumber,
    required model,
    endTime,
  });

  TaskToday.fromJson(Map json) {
    json["Data"] = {"ID": json["ID"], ...json["Data"]};

    tabNumber = json["Tab Number"];
    name = json["Data"][tabNumber == 3 ? "Activity" : "Name"];

    List startTimeBreakup = json["Data"][tabNumber == 3 ? "Time" : "Start"]
        .split(":")
        .map((val) => int.parse(val))
        .toList();
    startTime =
        TimeOfDay(hour: startTimeBreakup[0], minute: startTimeBreakup[1]);

    if (tabNumber == 2) {
      endTime = SchedulingModel.fromJson(json["Data"]).getEndTime();
    }

    switch (tabNumber) {
      case 2 || 6 || 7:
        model = SchedulingModel.fromJson(json["Data"]);
        break;

      case 3:
        model = AdHocModel.fromJson(DateTime.now(), json["Data"]);
    }
  }

  toJson() {
    return {
      "Tab Number": tabNumber,
      "Data": model.toJson(),
    };
  }
}
