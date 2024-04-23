import 'package:uuid/uuid.dart';

class Tab12SubEntryModel {
  String? uuid;
  String nextTask = "";
  DateTime date = DateTime(0);

  Tab12SubEntryModel({
    this.uuid,
    required this.nextTask,
    required this.date,
  });

  Map toJson() => {
        "ID": uuid ?? const Uuid().v4(),
        "Next Task": nextTask,
        "Date": date.toIso8601String(),
      };

  Tab12SubEntryModel.fromJson(Map json) {
    uuid = json["ID"];
    nextTask = json["Next Task"];
    date = DateTime.parse(json["Date"]);
  }

  Tab12SubEntryModel copyWith(
      {String? uuid, String? nextTask, DateTime? date}) {
    return Tab12SubEntryModel(
      uuid: uuid ?? this.uuid,
      nextTask: nextTask ?? this.nextTask,
      date: date ?? this.date,
    );
  }
}
