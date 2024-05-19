import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/reusables.dart';

final historyProvider = FutureProvider<Map<DateTime, int>>((ref) async {
  Map<DateTime, int> points = {};

  File file = ref.read(dbFilesProvider).requireValue[1]![0];
  Map content = jsonDecode(await file.readAsString());
  List dates = content.keys.toList();
  dates.sort(
    (a, b) {
      return DateTime.parse(b).difference(DateTime.parse(a)).inSeconds;
    },
  );

  for (String date in dates) {
    points[DateTime.parse(date)] = content[date]['points'];
  }

  return points;
});
