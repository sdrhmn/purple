import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objectbox/objectbox.dart';
import 'package:timely/modules/lifestyle/memory/data/memories_provider.dart';
import 'package:timely/modules/lifestyle/memory/memory_model.dart';
import 'package:timely/reusables.dart';

class MemoryRepositoryNotifier extends AsyncNotifier<void> {
  late final Store store;
  late final Box<MemoryModel> _memoryBox;

  @override
  FutureOr<void> build() {
    store = ref.read(storeProvider).requireValue;
    _memoryBox = store.box<MemoryModel>();
  }

  // Create or Update a MemoryModel
  Future<int> createOrUpdateMemory(MemoryModel memory) async {
    int id = await _memoryBox.putAsync(memory);
    ref.invalidate(memoriesProvider);
    return id; // If the memory has an ID, it updates, otherwise creates
  }

  // Read all memories
  Future<List<MemoryModel>> getAllMemories() async {
    return _memoryBox.getAllAsync();
  }

  // Read a single memory by ID
  Future<MemoryModel?> getMemoryById(int id) async {
    return _memoryBox.getAsync(id);
  }

  // Delete a memory by ID
  Future<bool> deleteMemory(int id) async {
    bool removed = await _memoryBox.removeAsync(id);
    ref.invalidate(memoriesProvider);
    return removed;
  }

  // Delete all memories
  Future<int> deleteAllMemories() async {
    return _memoryBox.removeAllAsync();
  }
}

final memoryRepositoryProvider =
    AsyncNotifierProvider<MemoryRepositoryNotifier, void>(
        MemoryRepositoryNotifier.new);
