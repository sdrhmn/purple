import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_9/views/tab_9_input_page.dart';
import 'package:timely/modules/tab_9/views/tab_9_detail_page.dart';
import 'package:timely/modules/tab_9/views/tab_9_summary_template.dart';
import 'package:timely/modules/tab_9/controllers/input/entry_input_controller.dart';
import 'package:timely/modules/tab_9/controllers/input/sub_entry_input_controller.dart';
import 'package:timely/modules/tab_9/controllers/output/output_controller.dart';
import 'package:timely/modules/tab_9/models/entry_model.dart';
import 'package:timely/reusables.dart';

class Tab9SummaryPage extends ConsumerStatefulWidget {
  const Tab9SummaryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _Tab9SummaryPageState();
}

class _Tab9SummaryPageState extends ConsumerState<Tab9SummaryPage> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(tab9OutputProvider);
    final controller = ref.read(tab9OutputProvider.notifier);

    return provider.when(
      data: (models) {
        return Tab9SummaryTemplate(
          models: models,
          onDismissed: (direction, entry, subEntries) {
            if (direction == DismissDirection.startToEnd) {
              controller.deleteEntry(entry);
              models.removeWhere((k, v) => k.uuid == entry.uuid!);
              setState(() {});
            } else {
              models.removeWhere((k, v) => k.uuid == entry.uuid!);
              setState(() {});

              controller.markEntryAsComplete(entry, subEntries);
            }
          },
          onPressedHome: () => ref.read(tabIndexProvider.notifier).setIndex(12),
          onPressedAdd: () {
            ref.invalidate(tab9EntryInputProvider);
            ref.invalidate(tab9SubEntryInputProvider);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: const Tab9InputPage(),
                  );
                },
              ),
            );
          },
          onTapEntry: (Tab9EntryModel entry) async {
            ref.read(tab9EntryInputProvider.notifier).setModel(entry);
            await Future.delayed(
              const Duration(milliseconds: 100),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(),
                        body: const Tab9InputPage(
                          showSubEntryMolecule: false,
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
          onTapSubEntry: (entry, subEntries) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: Tab9DetailPage(
                      entry: entry,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
      error: (_, __) => const Text("ERROR"),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
