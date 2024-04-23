import 'package:uuid/uuid.dart';

class Tab10Model {
  String? uuid;
  DateTime date = DateTime.now();
  double? amount = 0;
  String text_1 = "";
  int option = 1;
  bool isComplete = false;

  Tab10Model({
    this.uuid,
    this.amount,
    required this.date,
    required this.text_1,
    required this.option,
    required this.isComplete,
  });

  Tab10Model.fromJson(Map json) {
    String text_1 = json["Text_1"];
    double amount = json["Amount"];
    DateTime date = DateTime.parse(json["Date"]);
    int option = json["Option"];

    uuid = json["ID"];
    this.text_1 = text_1;
    this.amount = amount;
    this.date = date;
    this.option = option;
  }

  Map toJson() {
    return {
      "ID": const Uuid().v4(),
      "Date": date.toString().substring(0, 10),
      "Option": option,
      "Amount": amount,
      "Text_1": text_1,
    };
  }

  Tab10Model copyWith(
      {DateTime? date,
      String? uuid,
      String? text_1,
      int? option,
      double? amount,
      bool? isComplete}) {
    return Tab10Model(
      uuid: uuid ?? this.uuid,
      date: date ?? this.date,
      text_1: text_1 ?? this.text_1,
      amount: amount ?? this.amount,
      option: option ?? this.option,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
