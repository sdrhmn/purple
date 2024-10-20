import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';
import 'exercise_model.dart';

class ExerciseRepository extends AsyncNotifier<void> {
  late final Store _store;
  late final Box<Exercise> _exerciseBox;
  late final Box<DataRepeatExercise> _dataRepeatExerciseBox;

  @override
  Future<void> build() async {
    _store = ref.read(storeProvider).requireValue;
    _exerciseBox = _store.box<Exercise>();
    _dataRepeatExerciseBox = _store.box<DataRepeatExercise>();
  }

  // Create a new exercise
  Future<void> createExercise(Exercise exercise) async {
    final dataRepeatExercise = DataRepeatExercise(
      data: jsonEncode(exercise.toJson()),
    );
    if (exercise.repeats.isNotEmpty) {
      exercise.dataRepeatExercise.target = dataRepeatExercise;
    }

    await _exerciseBox.putAsync(exercise);
  }

  // Read all exercises
  Future<List<Exercise>> readAllExercises() async {
    return await _exerciseBox.getAllAsync();
  }

  // Read a specific exercise by ID
  Future<Exercise?> readExercise(int id) async {
    return await _exerciseBox.getAsync(id);
  }

  // Update an exercise
  Future<void> updateExercise(Exercise exercise) async {
    await _exerciseBox.putAsync(exercise);
  }

  // Delete an exercise
  Future<void> deleteExercise(int id) async {
    await _exerciseBox.removeAsync(id);
  }

  // Delete a DataRepeatExercise
  Future<void> deleteDataRepeatExercise(int id) async {
    await _dataRepeatExerciseBox.removeAsync(id);
  }
}

// Create a provider for the ExerciseRepository
final exerciseRepositoryProvider =
    AsyncNotifierProvider<ExerciseRepository, void>(() => ExerciseRepository());
