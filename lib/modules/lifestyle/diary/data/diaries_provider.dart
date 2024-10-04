import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/diary/data/diary_repository.dart';
import 'package:timely/modules/lifestyle/diary/diary_model.dart';

// FutureProvider to fetch all memories
final diariesProvider =
    FutureProvider.autoDispose<List<DiaryModel>>((ref) async {
  final diaryRepo = ref.read(diaryRepositoryProvider.notifier);
  return await diaryRepo.getAllDiary();
});
