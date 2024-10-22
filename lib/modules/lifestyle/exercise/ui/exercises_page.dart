import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/exercise/data/exercise_model.dart';
import 'package:timely/modules/lifestyle/exercise/data/exercise_provider.dart';
import 'package:timely/modules/lifestyle/exercise/data/exercise_repository.dart';
import 'package:timely/modules/lifestyle/exercise/ui/exercise_form.dart';
import 'exercise_tile.dart';

class ExercisesPage extends ConsumerWidget {
  const ExercisesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exerciseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Physical Fitness'),
      ),
      body: exercisesAsync.when(
        data: (exercises) {
          if (exercises.isEmpty) {
            return const Center(
              child: Text('No exercises found.'),
            );
          }
          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              return ExerciseTile(
                exercise: exercises[index],
                onEdit: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ExerciseForm(
                        exercise: exercises[index],
                        onSubmit: (exercise) async {
                          if (exercises[index].repeats.isNotEmpty) {
                            final updateRepeat = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Update Repeat'),
                                  content: const Text(
                                      'This exercise also has a repeat feature. Do you want to update the corresponding repeat exercise?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('No'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                    ),
                                    TextButton(
                                      child: const Text('Yes'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (updateRepeat == true) {
                              await ref
                                  .read(exerciseRepositoryProvider.notifier)
                                  .updateExerciseAndDataRepeatExercise(
                                      exercise);
                            } else {
                              await ref
                                  .read(exerciseRepositoryProvider.notifier)
                                  .updateExercise(exercise);
                            }
                          } else {
                            await ref
                                .read(exerciseRepositoryProvider.notifier)
                                .updateExercise(exercise);
                          }
                          ref.invalidate(exerciseProvider);
                          if (context.mounted) Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
                onDelete: () async {
                  final deleteResult = await _showDeleteConfirmationDialog(
                      context, exercises[index]);
                  if (deleteResult != null) {
                    await ref
                        .read(exerciseRepositoryProvider.notifier)
                        .deleteExercise(exercises[index].id);
                    if (deleteResult == DeleteOption.withRepeat) {
                      await ref
                          .read(exerciseRepositoryProvider.notifier)
                          .deleteDataRepeatExercise(exercises[index].id);
                    }
                    ref.invalidate(exerciseProvider);
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseForm(
                onSubmit: (exercise) async {
                  if (context.mounted) Navigator.of(context).pop();
                  await ref
                      .read(exerciseRepositoryProvider.notifier)
                      .createExercise(exercise);
                  ref.invalidate(exerciseProvider);
                },
              ),
            ),
          );
        },
        tooltip: 'Add Exercise',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<DeleteOption?> _showDeleteConfirmationDialog(
      BuildContext context, Exercise exercise) {
    return showDialog<DeleteOption>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Are you sure you want to delete this exercise?'),
              if (exercise.repeats.isNotEmpty) const SizedBox(height: 16),
              if (exercise.repeats.isNotEmpty)
                const Text(
                    'This exercise has a repeat feature. Do you want to delete it as well?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(height: 8),
            if (exercise.repeats.isNotEmpty) ...[
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pop(DeleteOption.withoutRepeat),
                child: const Text('Delete Exercise Only'),
              ),
              const SizedBox(height: 8),
            ],
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(
                  exercise.repeats.isNotEmpty
                      ? DeleteOption.withRepeat
                      : DeleteOption.withoutRepeat),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                exercise.repeats.isNotEmpty ? 'Delete Both' : 'Delete',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum DeleteOption {
  withRepeat,
  withoutRepeat,
}
