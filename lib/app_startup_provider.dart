import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/reusables.dart';

final appStartupProvider = FutureProvider<void>((ref) async {
  // ObjectBox
  await ref.read(storesProvider.future);

  return;
});
