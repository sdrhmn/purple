import 'package:flutter/material.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/modules/tab_3/models/ad_hoc_model.dart';

class Task {
  late final String name;
  TimeOfDay? endTime;
  late final int tabNumber;
  late final dynamic model;
  DateTime? timestamp;

  Task({
    required this.name,
    required this.tabNumber,
    required this.model,
    this.timestamp,
    this.endTime,
  });

  Task.fromJson(Map json) {
    json["Data"] = {"ID": json["ID"], ...json["Data"]};

    tabNumber = json["Tab Number"];
    name = json["Data"][tabNumber == 3 ? "Activity" : "Name"];
    timestamp =
        json['Timestamp'] != null ? DateTime.parse(json['Timestamp']) : null;

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
      "Timestamp": timestamp?.toString(),
      "Tab Number": tabNumber,
      "Data": model.toJson(),
    };
  }
}
