import 'package:flutter_riverpod/flutter_riverpod.dart';

final shouldFetchCompletedProvider = StateProvider<bool>((ref) {
  return false;
});
