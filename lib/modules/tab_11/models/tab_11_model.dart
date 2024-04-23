import 'package:uuid/uuid.dart';

class Tab11Model {
  String? uuid;
  String item = "";
  int qty = 0;
  bool urgent = false;

  Tab11Model({
    this.uuid,
    required this.item,
    required this.qty,
    required this.urgent,
  });

  Tab11Model.fromJson(Map json) {
    String item = json["Item"];
    int qty = json["Quantity"];

    uuid = json["ID"];
    this.item = item;
    this.qty = qty;
    urgent = json["Urgent"];
  }

  Map toJson() {
    return {
      "ID": const Uuid().v4(),
      "Item": item,
      "Quantity": qty,
      "Urgent": urgent,
    };
  }

  Tab11Model copyWith({
    String? uuid,
    String? item,
    int? qty,
    bool? urgent,
  }) {
    return Tab11Model(
      uuid: uuid ?? this.uuid,
      item: item ?? this.item,
      qty: qty ?? this.qty,
      urgent: urgent ?? this.urgent,
    );
  }
}
