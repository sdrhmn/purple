import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_5/models/spw.dart';
import 'package:timely/reusables.dart';

// Repositories are used to communicate to the external world eg. DB, REST API.

class Tab5RepositoryNotifier extends Notifier<AsyncValue<void>> {
  @override
  build() {
    return const AsyncData(null);
  }

  Future<void> writeSPWModel(SPWModel model) async {
    final tab5File = (await ref.read(dbFilesProvider.future))[5]![0];
    final jsonContent = jsonDecode(await tab5File.readAsString());
    String date = model.date.toString().substring(0, 10);
    jsonContent[date] = [];
    jsonContent[date].add(
      [
        model.sScore,
        model.pScore,
        model.wScore,
      ],
    );
    jsonContent[date].add(
      model.weight,
    );
    await tab5File.writeAsString(jsonEncode(jsonContent));
  }

  Future<List<SPWModel>> fetchSPWModels() async {
    final tab5File = (await ref.read(dbFilesProvider.future))[5]![0];
    final jsonContent = jsonDecode(await tab5File.readAsString());
    final spwModels = <SPWModel>[];
    for (final date in jsonContent.keys.toList().reversed) {
      final scores = jsonContent[date][0];
      final weight = jsonContent[date][1] ?? 0.0;
      spwModels.add(
        SPWModel(
          date: DateTime.parse(date),
          sScore: scores[0],
          pScore: scores[1],
          wScore: scores[2],
          weight: weight,
        ),
      );
    }

    return spwModels;
  }

  Future<void> deleteModel(SPWModel model) async {
    // Fetch the data
    final tab5File = (await ref.read(dbFilesProvider.future))[5]![0];
    Map jsonContent = jsonDecode(await tab5File.readAsString());

    jsonContent.removeWhere((key, value) {
      return key == model.date;
    });

    // Persist the data
    await tab5File.writeAsString(jsonEncode(jsonContent));
  }

  Future<void> editModel(SPWModel model) async {
    await deleteModel(model);
    await writeSPWModel(model);
  }

  Future<void> markModelAsComplete(SPWModel model) async {
    await deleteModel(model);
    final file = (await ref.read(dbFilesProvider.future))[5]![1];
    Map content = jsonDecode(await file.readAsString());
    content = {...content, ...model.toJson()};
    await file.writeAsString(jsonEncode(content));
  }
}

final tab5RepositoryProvider =
    NotifierProvider<Tab5RepositoryNotifier, AsyncValue<void>>(
        Tab5RepositoryNotifier.new);
