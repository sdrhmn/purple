import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/memory/data/memory_repository.dart';
import 'package:timely/modules/lifestyle/memory/memory_model.dart';

// FutureProvider to fetch all memories
final memoriesProvider =
    FutureProvider.autoDispose<List<MemoryModel>>((ref) async {
  final memoryRepo = ref.read(memoryRepositoryProvider.notifier);
  return await memoryRepo.getAllMemories();
});
