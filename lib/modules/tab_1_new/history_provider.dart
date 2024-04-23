import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/reusables.dart';

final historyProvider = FutureProvider<Map<DateTime, int>>((ref) async {
  Map<DateTime, int> points = {};

  File file = ref.read(dbFilesProvider).requireValue[1]![0];
  var content = jsonDecode(await file.readAsString());

  for (String date in content.keys) {
    points[DateTime.parse(date)] = content[date]['points'];
  }

  return points;
});
