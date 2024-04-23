import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/home/providers/todays_model_maps_provider.dart';
import 'package:timely/reusables.dart';

class EntryStructOutputNotifier<T, V,
        U extends EntryStructPendingRepositoryNotifier<T, V>>
    extends AutoDisposeAsyncNotifier<Map<T, List<V>>> {
  late File pendingFile;
  late File completedFile;
  final NotifierProvider<U, void> repoService;
  final Function entryModelizer;
  final Function subEntryModelizer;

  EntryStructOutputNotifier({
    required this.repoService,
    required this.entryModelizer,
    required this.subEntryModelizer,
  });

  @override
  FutureOr<Map<T, List<V>>> build() async {
    pendingFile = (await ref.read(dbFilesProvider.future))[9]![0];
    completedFile = (await ref.read(dbFilesProvider.future))[9]![1];

    return (await ref.read(repoService.notifier).fetchEntriesAndSubEntries(
        pendingFile, entryModelizer, subEntryModelizer));
  }

  Future<void> deleteEntry(T model) async =>
      await ref.read(repoService.notifier).deleteEntry(model, pendingFile);

  Future<void> deleteSubEntry(String entryUuid, V model) async => await ref
      .read(repoService.notifier)
      .deleteSubEntry(entryUuid, model, pendingFile);

  Future<void> markEntryAsComplete(T entry, List<V> subEntries) async {}

  Future<void> markSubEntryAsComplete(T entryModel, V subEntryModel) async {}
}

class EntryStructPendingRepositoryNotifier<T, V> extends Notifier<void> {
  @override
  void build() {}

  // Methods:

  // Create: entry, subEntry
  Future<void> writeEntry(model, File file, List? subEntries) async {
    final jsonContent = jsonDecode(await file.readAsString());

    jsonContent.add({
      ...model.toJson(),
      "SubEntries": subEntries ?? [],
    });
    await file.writeAsString(jsonEncode(jsonContent));
  }

  Future<void> writeSubEntry(
    String entryUuid,
    subEntry,
    File file,
    entryModel,
    entryModelizer,
    subEntryModelizer,
  ) async {
    List jsonContent = jsonDecode(await file.readAsString());
    bool isFound = false;
    for (int i in Iterable.generate(jsonContent.length)) {
      if (entryModelizer(jsonContent[i])!.uuid == entryUuid) {
        jsonContent[i]["SubEntries"].add(subEntry.toJson());
        isFound = true;
        break;
      }
    }

    await file.writeAsString(jsonEncode(jsonContent));

    if (!isFound) {
      await writeEntry(entryModel!, file, null);
      await writeSubEntry(
        entryUuid,
        subEntry,
        file,
        null,
        entryModelizer,
        subEntryModelizer,
      );
    }
  }

  // Read: entries and subEntries
  Future<Map<T, List<V>>> fetchEntriesAndSubEntries(
    File file,
    entryModelizer,
    subEntryModelizer,
  ) async {
    Map<T, List<V>> entriesAndSubEntries = {};
    final List jsonContent = jsonDecode(await file.readAsString());

    for (int i in Iterable.generate(jsonContent.length)) {
      T entryModel = entryModelizer(jsonContent[i]);
      entriesAndSubEntries[entryModel] = [];

      for (var json in jsonContent[i]["SubEntries"]) {
        entriesAndSubEntries[entryModel]!.add(subEntryModelizer(json));
      }
    }
    return entriesAndSubEntries;
  }

  // Update: entry, subEntry
  Future<void> updateEntry(
    model,
    File file,
    entryModelizer,
  ) async {
    List jsonContent = jsonDecode(await file.readAsString());
    for (int i in Iterable.generate(jsonContent.length)) {
      if (entryModelizer(jsonContent[i]).uuid == model.uuid) {
        jsonContent[i] = {
          ...model.toJson(),
          "SubEntries": jsonContent[i]["SubEntries"]
        };
        break;
      }
    }

    await file.writeAsString(jsonEncode(jsonContent));
  }

  Future<void> updateSubEntry(
      String entryUuid, subEntry, File file, entryModelizer) async {
    List jsonContent = jsonDecode(await file.readAsString());
    for (int i in Iterable.generate(jsonContent.length)) {
      if (entryModelizer(jsonContent[i]).uuid == entryUuid) {
        List subEntries = jsonContent[i]["SubEntries"];
        for (int j in Iterable.generate(subEntries.length)) {
          if (subEntries[j]["ID"] == subEntry.uuid) {
            subEntries[j] = subEntry.toJson();
            jsonContent[i]["SubEntries"] = subEntries;
            break;
          }
        }
        break;
      }
    }

    await file.writeAsString(jsonEncode(jsonContent));
  }

  // Delete: entry, subEntry
  Future<void> deleteEntry(entry, File file) async {
    List jsonContent = jsonDecode(await file.readAsString());

    jsonContent.removeWhere((element) => element["ID"] == entry.uuid);

    await file.writeAsString(jsonEncode(jsonContent));
  }

  Future<void> deleteSubEntry(
    String entryUuid,
    subEntry,
    File file,
  ) async {
    List jsonContent = jsonDecode(await file.readAsString());

    for (int i in Iterable.generate(jsonContent.length)) {
      if (jsonContent[i]["ID"] == entryUuid) {
        jsonContent[i]["SubEntries"]
            .removeWhere((element) => element["ID"] == subEntry.uuid);
      }
    }

    await file.writeAsString(jsonEncode(jsonContent));
  }
}

class OutputNotifier<T> extends AutoDisposeAsyncNotifier<List<T>> {
  late int tabNumber;
  late File pendingFile;
  late File completedFile;
  late Function modelizer;
  late final NotifierProvider<ListStructRepositoryNotifier<T>, void>
      repositoryServiceProvider;

  OutputNotifier({
    required this.tabNumber,
    required this.modelizer,
    required this.repositoryServiceProvider,
  });

  @override
  FutureOr<List<T>> build() async {
    pendingFile = (await ref.read(dbFilesProvider.future))[tabNumber]![0];
    completedFile = (await ref.read(dbFilesProvider.future))[tabNumber]![1];

    return await ref
        .read(repositoryServiceProvider.notifier)
        .fetchModels(modelizer, pendingFile);
  }

  Future<void> deleteModel(T model) async {
    await ref
        .read(repositoryServiceProvider.notifier)
        .deleteModel(model, pendingFile);
    ref.invalidate(todaysModelMapsProvider);
  }
}

class ListStructRepositoryNotifier<T> extends Notifier<void> {
  @override
  build() {
    return;
  }

  Future<void> writeModel(model, file) async {
    final jsonContent = jsonDecode(await file.readAsString());
    jsonContent.add(model.toJson());
    await file.writeAsString(jsonEncode(jsonContent));
  }

  Future<List<T>> fetchModels(Function modelizer, file) async {
    final jsonContent = jsonDecode(await file.readAsString());
    final models = <T>[];

    for (Map modelMap in jsonContent) {
      models.add(modelizer(modelMap));
    }

    return models;
  }

  Future<void> deleteModel(model, file) async {
    // Fetch the data
    List jsonContent = jsonDecode(await file.readAsString());

    jsonContent.removeWhere((modelMap) {
      return modelMap["ID"] == model.uuid;
    });

    // Persist the data
    await file.writeAsString(jsonEncode(jsonContent));
  }

  Future<void> editModel(model, file) async {
    await deleteModel(model, file);
    await writeModel(model, file);
  }
}

class EntryStructCompletedRepositoryNotifier<T> extends Notifier<void> {
  @override
  build() {
    return;
  }

  // Methods:
  // completeEntry
  // completeSubEntry

  Future<void> writeEntryAsComplete(entry, List subEntries, File file) async {
    // Check if the entry is already present or not
    // If it is, just append the subEntries
    // Else, create a new one from scratch.

    final jsonContent = jsonDecode(await file.readAsString());
    bool isFound = false;

    for (int i in Iterable.generate(jsonContent.length)) {
      if (jsonContent[i]["uuid"] == entry.uuid) {
        jsonContent[i]["SubEntries"] = [
          ...jsonContent[i]["SubEntries"],
          ...subEntries.map(
            (e) => e.toJson(),
          )
        ];

        isFound = true;
        break;
      }
    }

    if (!isFound) {
      jsonContent.add({
        ...entry.toJson(),
        "SubEntries": subEntries
            .map(
              (e) => e.toJson()..update("ID", (value) => e.uuid),
            )
            .toList(),
      });
    }

    await file.writeAsString(jsonEncode(jsonContent));
  }

  Future<void> writeSubEntryAsComplete(entry, subEntry, File file) async {
    // Go through the entries
    // If $entry exists, then append the subEntry into it
    // Else, create a new entry and then append the subEntry

    List jsonContent = jsonDecode(await file.readAsString());
    bool isFound = false;
    for (int i in Iterable.generate(jsonContent.length)) {
      if (jsonContent[i]["uuid"] == entry.uuid) {
        jsonContent[i]["SubEntries"].add(subEntry.toJson());
      }
    }

    if (!isFound) {
      // Create the entry
      jsonContent.add({
        ...entry.toJson(),
        "SubEntries": [subEntry.toJson()],
      });
    }

    await file.writeAsString(jsonEncode(jsonContent));
  }
}

final completedRepositoryProvider =
    NotifierProvider<EntryStructCompletedRepositoryNotifier, void>(
        EntryStructCompletedRepositoryNotifier.new);
