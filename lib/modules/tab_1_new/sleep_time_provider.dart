import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_2/controllers/output_controller.dart';

final sleepTimeProvider = FutureProvider<TimeOfDay>((ref) async {
  return await ref.read(tab2OutputProvider.notifier).fetchSleepTime();
});
