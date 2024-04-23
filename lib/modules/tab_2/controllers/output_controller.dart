import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/scheduling/scheduling_output_controller.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';

// This is the output controller for tab 2.
// It's job is to simply:
// 1) Fetch the scheduled tasks from the database
// 2) Allow users to delete and mark tasks as complete

final tab2OutputProvider = AutoDisposeAsyncNotifierProvider<
    SchedulingOutputNotifier<SchedulingModel>,
    Map<String, List<SchedulingModel>>>(() {
  return SchedulingOutputNotifier(2);
});
