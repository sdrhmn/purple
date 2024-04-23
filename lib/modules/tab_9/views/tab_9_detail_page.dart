import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_9/views/tab_9_sub_entry_input_page.dart';
import 'package:timely/modules/tab_9/views/tab_9_detail_template.dart';
import 'package:timely/modules/tab_9/controllers/input/sub_entry_input_controller.dart';
import 'package:timely/modules/tab_9/controllers/output/output_controller.dart';
import 'package:timely/modules/tab_9/models/entry_model.dart';
import 'package:timely/modules/tab_9/models/sub_entry_model.dart';

class Tab9DetailPage extends ConsumerStatefulWidget {
  final Tab9EntryModel entry;

  const Tab9DetailPage({
    super.key,
    required this.entry,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Tab9DetailPageState();
}

class _Tab9DetailPageState extends ConsumerState<Tab9DetailPage> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(tab9OutputProvider);
    final controller = ref.read(tab9OutputProvider.notifier);

    return provider.when(
      data: (models) {
        Tab9EntryModel entry = widget.entry;
        List<Tab9SubEntryModel> subEntries = [];

        for (Tab9EntryModel ent in models.keys) {
          if (ent.uuid == entry.uuid) {
            subEntries = models[ent]!;
            break;
          }
        }

        return Tab9DetailTemplate(
          entry: entry,
          subEntries: subEntries,
          onSubEntryDismissed: (direction, entry, subEntry) {
            if (direction == DismissDirection.startToEnd) {
              subEntries.removeWhere((v) => v.uuid == subEntry.uuid);
              controller.deleteSubEntry(entry.uuid!, subEntry);
              setState(() {});
            } else {
              subEntries.removeWhere((v) => v.uuid == subEntry.uuid);
              setState(() {});

              controller.markSubEntryAsComplete(entry, subEntry);
            }
          },
          onPressedAdd: (entry) {
            ref.invalidate(tab9SubEntryInputProvider);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: Tab9SubEntryInputPage(entryID: entry.uuid!),
                  );
                },
              ),
            );
          },
          onSubEntryTapped:
              (Tab9EntryModel entry, Tab9SubEntryModel subEntry) async {
            ref.read(tab9SubEntryInputProvider.notifier).setModel(subEntry);
            await Future.delayed(
              const Duration(milliseconds: 100),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(),
                        body: Tab9SubEntryInputPage(
                          entryID: entry.uuid!,
                        ),
                      );
                    },
                  ),
                );
              },
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
