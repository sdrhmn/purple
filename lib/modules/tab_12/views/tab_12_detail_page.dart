import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_12/views/tab_12_sub_entry_input_page.dart';
import 'package:timely/modules/tab_12/views/tab_12_detail_template.dart';
import 'package:timely/modules/tab_12/controllers/input/entry_input_controller.dart';
import 'package:timely/modules/tab_12/controllers/input/sub_entry_input_controller.dart';
import 'package:timely/modules/tab_12/controllers/output/output_controller.dart';
import 'package:timely/modules/tab_12/models/entry_model.dart';
import 'package:timely/modules/tab_12/models/sub_entry_model.dart';

class Tab12DetailPage extends ConsumerStatefulWidget {
  final Tab12EntryModel entry;

  const Tab12DetailPage({
    super.key,
    required this.entry,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _Tab12DetailPageState();
}

class _Tab12DetailPageState extends ConsumerState<Tab12DetailPage> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(tab12OutputProvider);
    final controller = ref.read(tab12OutputProvider.notifier);

    return provider.when(
      data: (models) {
        Tab12EntryModel entry = widget.entry;
        List<Tab12SubEntryModel> subEntries = [];

        for (Tab12EntryModel ent in models.keys) {
          if (ent.uuid == entry.uuid) {
            subEntries = models[ent]!;
            break;
          }
        }

        return Tab12DetailTemplate(
          onTapSubEntry: (entry, subEntry) async {
            ref.read(tab12EntryInputProvider.notifier).setEntry(entry);
            ref.read(tab12SubEntryInputProvider.notifier).setModel(subEntry);

            await Future.delayed(
              const Duration(milliseconds: 100),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(),
                        body: Tab12SubEntryInputPage(
                          entryID: entry.uuid!,
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
          entry: widget.entry,
          subEntries: subEntries,
          onSubEntryDismissed: (direction, entry, subEntry) {
            if (direction == DismissDirection.startToEnd) {
              subEntries.removeWhere((v) => v.uuid == subEntry.uuid);
              controller.deleteSubEntry(entry.uuid!, subEntry);
              setState(() {});
            } else {
              subEntries.removeWhere((v) => v.uuid == subEntry.uuid);
              setState(() {});
            }
          },
          onPressedAdd: (entry) {
            ref.invalidate(tab12SubEntryInputProvider);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: Tab12SubEntryInputPage(entryID: entry.uuid!),
                  );
                },
              ),
            );
          },
        );
      },
      error: (_, __) => const Text("ERROR"),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
