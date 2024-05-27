import 'package:flutter_riverpod/flutter_riverpod.dart';

final shouldFetchCompletedProvider = AutoDisposeStateProvider<bool>((ref) {
  return false;
});
