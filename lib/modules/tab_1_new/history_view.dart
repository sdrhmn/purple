import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_1_new/history_provider.dart';
import 'package:timely/reusables.dart';

class Tab1HistoryView extends ConsumerWidget {
  const Tab1HistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(historyProvider);

    return Stack(children: [
      provider.when(
        data: (data) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                color: index % 2 == 0 ? Colors.purple[700] : Colors.purple[800],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text(DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY)
                        .format(data.keys.toList()[index])),
                    Expanded(child: Container()),
                    Text(
                      data.values.toList()[index].toString(),
                    ),
                  ]),
                ),
              );
            },
            itemCount: data.keys.length,
          );
        },
        error: (_, __) => const Text("ERROR"),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      Column(
        children: [
          Expanded(
            child: Container(),
          ),
          NavigationRowMolecule(
            onPressedHome: () =>
                ref.read(tabIndexProvider.notifier).setIndex(12),
            hideAddButton: true,
          ),
          const SizedBox(
            height: 20,
          )
        ],
      )
    ]);
  }
}
