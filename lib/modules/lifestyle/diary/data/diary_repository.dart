import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/diary/data/diaries_provider.dart';
import 'package:timely/modules/lifestyle/diary/diary_model.dart';
import 'package:timely/modules/tasks/ui/tabs/lifestyle_status_info_provider.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

class DiaryRepositoryNotifier extends AsyncNotifier<void> {
  late final Store store;
  late final Box<DiaryModel> box;

  @override
  FutureOr<void> build() {
    store = ref.read(storeProvider).requireValue;
    box = store.box<DiaryModel>();
  }

  // Create or Update a MemoryModel
  Future<int> createOrUpdateDiary(DiaryModel memory) async {
    int id = await box.putAsync(memory);
    ref.invalidate(diariesProvider);
    ref.invalidate(lifestyleStatusInfoProvider);

    return id; // If the memory has an ID, it updates, otherwise creates
  }

  // Read all memories
  Future<List<DiaryModel>> getAllDiary() async {
    return box.getAllAsync();
  }

  // Read a single memory by ID
  Future<DiaryModel?> getDiaryById(int id) async {
    return box.getAsync(id);
  }

  // Delete a memory by ID
  Future<bool> deleteDiary(int id) async {
    bool removed = await box.removeAsync(id);
    ref.invalidate(diariesProvider);
    ref.invalidate(lifestyleStatusInfoProvider);

    return removed;
  }

  // Get Status Info for Diary
  Future<List<dynamic>> getStatusInfo() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final query = box
        .query(DiaryModel_.date.between(
            startOfDay.millisecondsSinceEpoch, now.millisecondsSinceEpoch))
        .build();

    final entriesToday = await query.findAsync();
    final lastEntry = box
        .query()
        .order(DiaryModel_.date, flags: Order.descending)
        .build()
        .findFirst();

    return [
      entriesToday.isNotEmpty, // Status: true if any entry today
      lastEntry?.date // Last entry's date
    ];
  }
}

final diaryRepositoryProvider =
    AsyncNotifierProvider<DiaryRepositoryNotifier, void>(
        DiaryRepositoryNotifier.new);
