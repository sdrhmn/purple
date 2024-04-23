import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/scheduling/scheduling_output_controller.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';

final tab7OutputProvider = AutoDisposeAsyncNotifierProvider<
    SchedulingOutputNotifier<SchedulingModel>,
    Map<String, List<SchedulingModel>>>(() {
  return SchedulingOutputNotifier(7);
});
