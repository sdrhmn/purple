import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/tab_5/controllers/output_controller.dart';
import 'package:timely/modules/tab_5/models/spw.dart';
import 'package:timely/modules/tab_5/repositories/tab_5_repo.dart';

class Tab5InputNotifier extends Notifier<SPWModel> {
  @override
  build() {
    return SPWModel(date: DateTime.now(), sScore: 1, pScore: 1, wScore: 1);
  }

  String getFormattedDate() {
    return DateFormat("dd-MMM-yyyy").format(state.date);
  }

  void setSScore(sScore) {
    state = state.copyWith(sScore: sScore);
  }

  void setPScore(pScore) {
    state = state.copyWith(pScore: pScore);
  }

  void setWScore(wScore) {
    state = state.copyWith(wScore: wScore);
  }

  void setWeight(weight) {
    try {
      state = state.copyWith(weight: double.parse(weight));
    } catch (e) {
      // Skip.w
    }
  }

  Future<void> syncToDB() async {
    await ref.read(tab5RepositoryProvider.notifier).writeSPWModel(state);
    ref.invalidate(tab5OutputProvider);
  }

  void setModel(SPWModel model) {
    state = model;
  }

  void setDate(date) {
    state = state.copyWith(date: date.toString().substring(0, 10));
  }
}

final tab5InputProvider = NotifierProvider<Tab5InputNotifier, SPWModel>(() {
  return Tab5InputNotifier();
});
