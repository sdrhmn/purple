import 'package:uuid/uuid.dart';

class Tab8Model {
  DateTime date = DateTime.now();
  String? uuid;
  String title = "";
  String description = "";
  int lsj = 0;
  int hml = 0;

  Tab8Model({
    this.uuid,
    required this.date,
    required this.title,
    required this.description,
    required this.lsj,
    required this.hml,
  });

  Tab8Model.fromJson(Map json) {
    uuid = json["ID"];
    date = DateTime.parse(json["Date"]);
    title = json["Title"];
    description = json["Description"];
    lsj = json["LSJ"];
    hml = json["HML"];
  }

  Map toJson() {
    return {
      "ID": uuid ?? const Uuid().v4(),
      "Date": date.toString().substring(0, 10),
      "Title": title,
      "Description": description,
      "LSJ": lsj,
      "HML": hml,
    };
  }

  Tab8Model copywith({
    String? uuid,
    DateTime? date,
    String? title,
    String? description,
    int? lsj,
    int? hml,
  }) {
    return Tab8Model(
      uuid: uuid ?? this.uuid,
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
      lsj: lsj ?? this.lsj,
      hml: hml ?? this.hml,
    );
  }
}
