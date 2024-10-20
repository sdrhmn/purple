import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rrule/rrule.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/modules/lifestyle/exercise/data/exercise_model.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tasks/models/repetition_data_model.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

final appStartupProvider = FutureProvider<void>((ref) async {
  // ObjectBox
  await ref.read(storeProvider.future);

  // Modify repeat tasks
  // Get all repeat tasks
  // Loop over those whose next occurence is today
  // Change the task.date to the next occurence
  // Save to the database
  await () async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    Store taskStore = ref.read(storeProvider).requireValue;
    Box<RepetitionData> repeatTaskBox = taskStore.box<RepetitionData>();
    Box<DataTask> taskBox = taskStore.box<DataTask>();

    final query = (taskBox.query(DataTask_.dateTime.betweenDate(
            DateTime(now.year, now.month, now.day, 0, 0),
            DateTime(now.year, now.month, now.day, 23, 59))))
        .build();

    List<RepetitionData> repetitionDatas = (await repeatTaskBox.getAllAsync());
    List<Task> todaysTasks =
        (await query.findAsync()).map((e) => Task.fromDataTask(e)).toList();

    List<DataTask> _ = [];

    for (RepetitionData repetitionData in repetitionDatas) {
      Task task = Task.fromJson(jsonDecode(repetitionData.task))
        ..repeatRule = SchedulingModel.fromJson(jsonDecode(repetitionData.data))
        ..repetitionDataId = repetitionData.id;
      DateTime next = task.repeatRule!.getNextOccurrenceDateTime();

      task.date = DateTime(next.year, next.month, next.day);

      if (DateTime(next.year, next.month, next.day) == today &&
          task.date!
              .copyWith(hour: task.time?.hour, minute: task.time?.minute)
              .isAfter(DateTime.now()) &&
          today.isBefore(
              task.repeatRule!.endDate ?? today.copyWith(day: today.day + 1))) {
        // Check if it exists in today's tasks or not
        if (todaysTasks
            .where((task) => task.repeatRule != null)
            .map((task) => task.repetitionDataId)
            .toList()
            .contains(repetitionData.id)) {
        }
        // If it does NOT contain
        else {
          _.add(
            DataTask(
                name: task.activity,
                dateTime: next.copyWith(
                  hour: task.time?.hour,
                  minute: task.time!.minute,
                ),
                data: jsonEncode(task.toJson()))
              ..repetitionData.target = repetitionData,
          );
          NotifService().scheduleRepeatTaskNotifs(task);
        }
      }
    }

    await taskBox.putManyAsync(_);
  }();

  () async {
    Store taskStore = ref.read(storeProvider).requireValue;
    Box<DataTask> taskBox = taskStore.box<DataTask>();

    final query = taskBox
        .query(DataTask_.name
            .equals("Sleep")
            .and(DataTask_.dateTime.lessThanDate(DateTime.now())))
        .build();

    print("DELETED ${await query.removeAsync()} SLEEP TASK(S)");
  }();

  () async {
    Store store = ref.read(storeProvider).requireValue;
    Box<DataRepeatExercise> dataRepeatExerciseBox =
        store.box<DataRepeatExercise>();
    Box<Exercise> exerciseBox = store.box<Exercise>();

    List<DataRepeatExercise> allDataRepeatExercises =
        await dataRepeatExerciseBox.getAllAsync();

    DateTime today = DateTime.now();

    for (var dataRepeatExercise in allDataRepeatExercises) {
      Exercise exercise =
          Exercise.fromJson(jsonDecode(dataRepeatExercise.data));

      if (exercise.repeats.isNotEmpty) {
        RecurrenceRule rrule = RecurrenceRule.fromString(exercise.repeats);
        DateTime? nextOccurrence = rrule
            .getInstances(
              start: today.copyWith(isUtc: true),
            )
            .take(1)
            .firstOrNull;

        if (nextOccurrence != null &&
            nextOccurrence.year == today.year &&
            nextOccurrence.month == today.month &&
            nextOccurrence.day == today.day) {
          // Check if the exercise already exists for today
          final query = exerciseBox
              .query(Exercise_.date.betweenDate(
                      today.copyWith(
                          hour: 0, minute: 0, second: 0, millisecond: 0),
                      today.copyWith(
                          hour: 23, minute: 59, second: 59, millisecond: 999)) &
                  Exercise_.dataRepeatExercise.equals(dataRepeatExercise.id))
              .build();

          if (query.count() == 0) {
            // Create a new exercise for today
            Exercise newExercise = Exercise(
              purpose: exercise.purpose,
              data: exercise.data,
              date: today,
              time: DateTime(today.year, today.month, today.day,
                  exercise.time.hour, exercise.time.minute),
              duration: exercise.duration,
              repeats: exercise.repeats,
            );
            newExercise.dataRepeatExercise.targetId = dataRepeatExercise.id;

            await exerciseBox.putAsync(newExercise);
          }

          query.close();
        }
      }
    }
  }();

  return;
});
