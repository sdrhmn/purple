import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/tab_8/controllers/output_controller.dart';
import 'package:timely/modules/tab_8/models/tab_8_model.dart';
import 'package:timely/modules/tab_8/repositories/tab_8_repo.dart';
import 'package:timely/reusables.dart';

class Tab8InputNotifier extends Notifier<Tab8Model> {
  @override
  Tab8Model build() {
    return Tab8Model(
      title: "",
      date: DateTime.now(),
      lsj: 1,
      hml: 1,
      description: "",
    );
  }

  // Setters
  void setTitle(String title) {
    state = state.copywith(title: title);
  }

  void setDate(DateTime date) {
    state = state.copywith(date: date);
  }

  void setLSJ(int lsj) {
    state = state.copywith(lsj: lsj);
  }

  void setHML(int hml) {
    state = state.copywith(hml: hml);
  }

  void setDescription(String description) {
    state = state.copywith(description: description);
  }

  void setModel(Tab8Model model) {
    state = model;
  }

  // Methods
  Future<void> syncToDB() async {
    final file = (await ref.read(dbFilesProvider.future))[8]![0];

    if (state.uuid != null) {
      await ref.read(tab8RepositoryProvider.notifier).editModel(state, file);
    } else {
      await ref.read(tab8RepositoryProvider.notifier).writeModel(state, file);
    }
    ref.invalidate(tab8OutputProvider);
  }

  String getFormattedDate() {
    return DateFormat("dd-MMM-yyyy").format(state.date);
  }

  Future<void> syncEditedModel() async {
    final file = (await ref.read(dbFilesProvider.future))[8]![0];

    await ref.read(tab8RepositoryProvider.notifier).editModel(state, file);
  }
}

final tab8InputProvider =
    NotifierProvider<Tab8InputNotifier, Tab8Model>(Tab8InputNotifier.new);
