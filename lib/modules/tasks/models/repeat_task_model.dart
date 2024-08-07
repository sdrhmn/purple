import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';

class RepeatTask {
  int? id;
  SchedulingModel repeatRule;

  RepeatTask({
    this.id,
    required this.repeatRule,
  });

  Map toJson() {
    return {
      'id': id,
      'repeat_rule': repeatRule.toJson(),
    };
  }

  factory RepeatTask.fromJson(Map json) {
    return RepeatTask(
        id: json['id'],
        repeatRule: SchedulingModel.fromJson(json['repeat_rule']));
  }

  factory RepeatTask.fromDataRepeatTask(DataRepeatTask dataRepeatTask) {
    return RepeatTask(
      id: dataRepeatTask.id,
      repeatRule: SchedulingModel.fromJson(
        jsonDecode(dataRepeatTask.data),
      ),
    );
  }
}

@Entity()
class DataRepeatTask {
  @Id()
  int id = 0;
  String data;
  String task;

  DataRepeatTask({
    id,
    required this.data,
    required this.task,
  }) {
    this.id = id ?? 0;
  }
}
