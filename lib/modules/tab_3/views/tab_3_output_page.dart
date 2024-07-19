import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/main.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tab_3/controllers/show_completed_controller.dart';
import 'package:timely/modules/tab_3/models/ad_hoc_model.dart';
import 'package:timely/modules/tab_3/repositories/tab_3_repo.dart';
import 'package:timely/modules/tab_3/views/tab_3_input_page.dart';
import 'package:timely/modules/tab_3/views/tab_3_output_template.dart';
import 'package:timely/modules/tab_3/controllers/input_controller.dart';
import 'package:timely/modules/tab_3/controllers/output_controller.dart';

class Tab3OutputPage extends ConsumerStatefulWidget {
  const Tab3OutputPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Tab3OutputPageState();
}

class _Tab3OutputPageState extends ConsumerState<Tab3OutputPage> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(tab3OutputProvider);
    final controller = ref.read(tab3OutputProvider.notifier);

    return provider.when(
        data: (models) {
          return Tab3OutputTemplate(
            cannotBeMarkedComplete: ref.read(shouldFetchCompletedProvider),
            checkbox: Checkbox(
                value: ref.watch(shouldFetchCompletedProvider),
                onChanged: (value) {
                  ref.read(shouldFetchCompletedProvider.notifier).state =
                      value!;
                }),
            models: models,
            onDismissed: (direction, model) {
              if (direction == DismissDirection.startToEnd) {
                controller.deleteModel(model);
                if (model.date != null && model.startTime != null) {
                  NotifService().cancelNotif((model.notifId));
                  NotifService().cancelReminders(model);
                }
              } else {
                controller.markComplete(model);
                NotifService().cancelNotif(model.notifId);
                NotifService().cancelReminders(model);
              }
            },
            onTap: (model) {
              ref.read(tab3InputProvider.notifier).setModel(model);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(),
                      body: const Tab3InputPage(),
                    );
                  },
                ),
              );
            },
            onPressedHome: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const PurpleTimeHomePage(),
                  ),
                  (Route<dynamic> route) => false);
            },
            onPressedAdd: () {
              ref.invalidate(tab3InputProvider);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(),
                      body: const Tab3InputPage(),
                    );
                  },
                ),
              );
            },
            onNotifIconPressed:
                (bool value, AdHocModel model, String date, int index) async {
              if (value == true) {
                NotifService().scheduleAdHocTaskNotifs(model);
              } else {
                NotifService().cancelNotif(model.notifId);
                NotifService().cancelReminders(model);
              }

              await ref
                  .read(tab3RepositoryProvider.notifier)
                  .editModel(model.copyWith(notifOn: value));

              ref.invalidate(tab3OutputProvider);

              setState(() {});
            },
          );
        },
        error: (_, __) => const Text("ERROR"),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
