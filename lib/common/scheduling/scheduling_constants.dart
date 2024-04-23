import 'package:flutter/material.dart';

class SchedulingConstants {
  static List<DropdownMenuItem> repeatDropdownButtonItems = [
    const DropdownMenuItem(
      value: "Daily",
      child: Text("Daily"),
    ),
    const DropdownMenuItem(
      value: "Weekly",
      child: Text("Weekly"),
    ),
    const DropdownMenuItem(
      value: "Yearly",
      child: Text("Yearly"),
    ),
    const DropdownMenuItem(
      value: "Monthly",
      child: Text("Monthly"),
    ),
  ];
}
