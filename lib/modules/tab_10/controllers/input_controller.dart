import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/tab_10/controllers/output_controller.dart';
import 'package:timely/modules/tab_10/models/tab_10_model.dart';
import 'package:timely/modules/tab_10/repositories/tab_10_repositories.dart';
import 'package:timely/reusables.dart';

class Tab10InputNotifier extends Notifier<Tab10Model> {
  @override
  build() {
    return Tab10Model(
      date: DateTime.now(),
      text_1: "",
      option: 1,
      isComplete: false,
    );
  }

  String getFormattedDate() {
    return DateFormat("dd-MMM-yyyy").format(state.date);
  }

  void setAmount(String amount) {
    try {
      state = state.copyWith(amount: double.parse(amount));
    } catch (e) {
      // Ski
    }
  }

  void setText_1(String text_1) {
    state = state.copyWith(text_1: text_1);
  }

  void setOption(int option) {
    state = state.copyWith(option: option);
  }

  void setDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  void setModel(Tab10Model model) {
    state = model;
  }

  Future<void> syncToDB() async {
    final file = (await ref.read(dbFilesProvider.future))[10]![0];

    if (state.uuid != null) {
      await ref.read(tab10RepositoryProvider.notifier).editModel(state, file);
    } else {
      await ref.read(tab10RepositoryProvider.notifier).writeModel(state, file);
    }

    ref.invalidate(tab10OutputProvider);
  }
}

final tab10InputProvider = NotifierProvider<Tab10InputNotifier, Tab10Model>(() {
  return Tab10InputNotifier();
});
