import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_12/views/tab_12_input_page.dart';
import 'package:timely/modules/tab_12/views/tab_12_detail_page.dart';
import 'package:timely/modules/tab_12/views/tab_12_summary_template.dart';
import 'package:timely/modules/tab_12/controllers/input/entry_input_controller.dart';
import 'package:timely/modules/tab_12/controllers/input/sub_entry_input_controller.dart';
import 'package:timely/modules/tab_12/controllers/output/output_controller.dart';
import 'package:timely/modules/tab_12/models/entry_model.dart';
import 'package:timely/reusables.dart';

class Tab12SummaryPage extends ConsumerStatefulWidget {
  const Tab12SummaryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _Tab12SummaryPageState();
}

class _Tab12SummaryPageState extends ConsumerState<Tab12SummaryPage> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(tab12OutputProvider);
    final controller = ref.read(tab12OutputProvider.notifier);

    return provider.when(
      data: (models) {
        return Tab12SummaryTemplate(
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
            ref.invalidate(tab12EntryInputProvider);
            ref.invalidate(tab12SubEntryInputProvider);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: const Tab12InputPage(),
                  );
                },
              ),
            );
          },
          onTapEntry: (Tab12EntryModel entry) async {
            ref.read(tab12EntryInputProvider.notifier).setEntry(entry);
            await Future.delayed(
              const Duration(milliseconds: 100),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(),
                        body: const Tab12InputPage(
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
                    body: Tab12DetailPage(
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
