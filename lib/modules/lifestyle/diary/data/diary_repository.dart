import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objectbox/objectbox.dart';
import 'package:timely/modules/lifestyle/diary/data/diaries_provider.dart';
import 'package:timely/modules/lifestyle/diary/diary_model.dart';
import 'package:timely/reusables.dart';

class DiaryRepositoryNotifier extends AsyncNotifier<void> {
  late final Store store;
  late final Box<DiaryModel> _memoryBox;

  @override
  FutureOr<void> build() {
    store = ref.read(storeProvider).requireValue;
    _memoryBox = store.box<DiaryModel>();
  }

  // Create or Update a MemoryModel
  Future<int> createOrUpdateDiary(DiaryModel memory) async {
    int id = await _memoryBox.putAsync(memory);
    ref.invalidate(diariesProvider);
    return id; // If the memory has an ID, it updates, otherwise creates
  }

  // Read all memories
  Future<List<DiaryModel>> getAllDiary() async {
    return _memoryBox.getAllAsync();
  }

  // Read a single memory by ID
  Future<DiaryModel?> getDiaryById(int id) async {
    return _memoryBox.getAsync(id);
  }

  // Delete a memory by ID
  Future<bool> deleteDiary(int id) async {
    bool removed = await _memoryBox.removeAsync(id);
    ref.invalidate(diariesProvider);
    return removed;
  }
}

final diaryRepositoryProvider =
    AsyncNotifierProvider<DiaryRepositoryNotifier, void>(
        DiaryRepositoryNotifier.new);
