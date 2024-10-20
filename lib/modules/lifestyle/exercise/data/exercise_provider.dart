import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'exercise_repository.dart';
import 'exercise_model.dart';

// A FutureProvider to fetch all exercises
final exerciseProvider = FutureProvider<List<Exercise>>((ref) async {
  // Obtain the repository from the provider
  final exerciseRepo = ref.watch(exerciseRepositoryProvider.notifier);

  // Fetch and return all exercises
  return await exerciseRepo.readAllExercises();
});
