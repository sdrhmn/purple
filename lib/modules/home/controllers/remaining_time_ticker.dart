import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timely/reusables.dart';

final remainingTimeTickerProvider = StreamProvider<String>((ref) async* {
  File tabOneFile = (await ref.read(dbFilesProvider.future))[1]![0];
  Map tabOneData = jsonDecode(await tabOneFile.readAsString());

  // First, check if today's date exists in the database
  String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  try {
    var interval = tabOneData[todayDate];

    String time2String = interval[1];
    DateTime time2 = DateFormat("yyyy-MM-dd HH:mm")
        .parse("$todayDate ${time2String.replaceAll(" ", "")}");
    while (true) {
      DateTime now = DateTime.now();

      await Future.delayed(const Duration(seconds: 1));
      Duration difference = time2.difference(now);
      yield !(difference.inHours < 0)
          ? "${difference.inHours}:${difference.inMinutes % 60}:${difference.inSeconds % 60}"
          : "Timer";
    }
  } catch (e) {
    // Skip.
  }
});
