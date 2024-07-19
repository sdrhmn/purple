import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/common/scheduling/scheduling_repository.dart';
import 'package:timely/modules/tab_10/models/tab_10_model.dart';
import 'package:timely/modules/tab_10/repositories/tab_10_repositories.dart';
import 'package:timely/modules/tab_11/models/tab_11_model.dart';
import 'package:timely/modules/tab_11/repositories/tab_11_repo.dart';
import 'package:timely/modules/tab_12/models/entry_model.dart';
import 'package:timely/modules/tab_12/models/sub_entry_model.dart';
import 'package:timely/modules/tab_12/repositories/tab_12_repo.dart';
import 'package:timely/modules/tab_2/pages/tab_2_input_page.dart';
import 'package:timely/modules/tab_3/models/ad_hoc_model.dart';
import 'package:timely/modules/tab_3/repositories/tab_3_repo.dart';
import 'package:timely/modules/tab_3/views/tab_3_input_page.dart';
import 'package:timely/modules/tab_5/models/spw.dart';
import 'package:timely/modules/tab_5/repositories/tab_5_repo.dart';
import 'package:timely/modules/tab_5/views/tab_5_input_page.dart';
import 'package:timely/modules/tab_6/pages/tab_6_input_page.dart';
import 'package:timely/modules/tab_8/models/tab_8_model.dart';
import 'package:timely/modules/tab_8/repositories/tab_8_repo.dart';
import 'package:timely/modules/tab_9/models/entry_model.dart';
import 'package:timely/modules/tab_9/models/sub_entry_model.dart';
import 'package:timely/modules/tab_9/repositories/tab_9_repo.dart';
import 'package:timely/modules/home/views/work_in_progress.dart';
import 'package:timely/modules/tab_1_new/history_view.dart';
import 'package:timely/modules/tab_2/pages/tab_2_output_page.dart';
import 'package:timely/modules/tab_3/views/tab_3_output_page.dart';
import 'package:timely/modules/tab_5/views/tab_5_output_page.dart';
import 'package:timely/modules/tab_6/pages/tab_6_output_page.dart';
import 'package:timely/modules/completed_tasks/completed_tasks_page.dart';
import 'package:timely/modules/home/views/launch_screen.dart';
import 'package:timely/values.dart';

export 'package:timely/common/buttons.dart';
export 'package:timely/common/inputs.dart';

// Providers
final colorProvider = Provider<List<Color>>((ref) {
  return [
    Colors.purple,
    Colors.indigo,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.red
  ];
});

final dbFilesProvider = FutureProvider<Map<int, List<File>>>(
  (ref) async {
    Directory docDir = await getApplicationDocumentsDirectory();
    Map<int, List<File>> files = {};

    void createDefaultEntry(int tabNumber) {
      File file = File('${docDir.path}/tab_${tabNumber}_pending.json');

      switch (tabNumber) {
        case 2:
          ref.read(schedulingRepositoryServiceProvider.notifier).writeModel(
                SchedulingModel(
                  name: "Sleep",
                  startTime: const TimeOfDay(hour: 22, minute: 0),
                  startDate: DateTime.now(),
                  dur: const Duration(hours: 8),
                  every: 1,
                  basis: Basis.day,
                  frequency: Frequency.daily,
                  repetitions: {},
                ),
                file,
              );
          break;

        case 6 || 7:
          ref.read(schedulingRepositoryServiceProvider.notifier).writeModel(
                SchedulingModel(
                  name: "This is a sample entry that repeats daily.",
                  startTime: TimeOfDay.now(),
                  startDate: DateTime.now(),
                  dur: Duration.zero,
                  every: 1,
                  basis: Basis.day,
                  frequency: Frequency.daily,
                  repetitions: {},
                ),
                file,
              );
          break;

        case 3:
          ref.read(tab3RepositoryProvider.notifier).writeModel(
                AdHocModel(
                  name: "This is a sample entry.",
                  priority: 0,
                  startTime: TimeOfDay.now(),
                  date: DateTime.now(),
                  notifOn: true,
                ),
              );

        // case 4:
        //   // ref.read(tab4RepositoryProvider.notifier).writeModel(
        //   //       Tab3Model(text_1: "This is a sample entry.", priority: 0),
        //   //     );

        case 5:
          ref.read(tab5RepositoryProvider.notifier).writeSPWModel(
                SPWModel(
                  date: DateTime.now(),
                  sScore: 0,
                  pScore: 0,
                  wScore: 0,
                ),
              );

        case 8:
          ref.read(tab8RepositoryProvider.notifier).writeModel(
                Tab8Model(
                    date: DateTime.now(),
                    title: "This is a sample entry.",
                    description: "This is a sample description.",
                    lsj: 0,
                    hml: 0),
                file,
              );

        case 9:
          ref.read(tab9RepositoryProvider.notifier).writeEntry(
            const Tab9EntryModel(
                condition: "A sample condition.",
                criticality: 0,
                care: "A sample care.",
                lessonLearnt: "A sample lesson."),
            file,
            [
              Tab9SubEntryModel(
                  date: DateTime.now(),
                  time: "00:00",
                  task: "A sample task.",
                  description: "A sample descrption."),
            ],
          );

        case 10:
          ref.read(tab10RepositoryProvider.notifier).writeModel(
                Tab10Model(
                  date: DateTime.now(),
                  text_1: "Some sample text.",
                  amount: 100.0,
                  option: 1,
                  isComplete: false,
                ),
                file,
              );

        case 11:
          ref.read(tab11RepositoryProvider.notifier).writeModel(
                Tab11Model(
                  item: "A sample item that is not urgent.",
                  qty: 10,
                  urgent: false,
                ),
                file,
              );

        case 12:
          ref.read(tab12RepositoryProvider.notifier).writeEntry(
            Tab12EntryModel(
              activity: "A sample activity",
              objective: 'An objective.',
              tab2Model: SchedulingModel(
                name: "This is a sample entry that repeats daily.",
                startTime: TimeOfDay.now(),
                startDate: DateTime.now(),
                endDate: DateTime.now(),
                dur: Duration.zero,
                every: 1,
                basis: Basis.day,
                frequency: Frequency.daily,
                repetitions: {},
              ),
              importance: 1,
            ),
            file,
            [
              Tab12SubEntryModel(
                nextTask: "A sample task.",
                date: DateTime.now(),
              ),
            ],
          );
      }
    }

    for (int tabNumber in List.generate(7, (index) => index + 1)) {
      File pending = File('${docDir.path}/tab_${tabNumber}_pending.json');
      File completed = File('${docDir.path}/tab_${tabNumber}_completed.json');

      var temp = 0;
      for (File file in [pending, completed]) {
        if (![3, 4].contains(tabNumber)) {
          await file.create();
          if ((await file.readAsString()).isEmpty) {
            if (![1, 5].contains(tabNumber)) {
              await file.writeAsString("[]");
            } else {
              await file.writeAsString("{}");
            }

            if (temp == 0) {
              createDefaultEntry(tabNumber);
            }
          }
          temp++;
        }
      }

      // Create completed file for tab 3
      if (tabNumber == 3) {
        await completed.create();
        (await completed.readAsString()).isEmpty
            ? await completed
                .writeAsString('{"scheduled": {}, "unscheduled":[]}')
            : null;
      }

      if ([2, 6, 7].contains(tabNumber)) {
        File current =
            File('${docDir.path}/tab_${tabNumber}_current_activities.json');
        await current.create();
        if ((await current.readAsString()).isEmpty) {
          await current.writeAsString("[]");
        }
      }

      files[tabNumber] = [
        pending,
        completed,
      ];
    }

    // Tab 3 non-scheduled file
    File scheduled = File('${docDir.path}/tab_3_scheduled.json');
    File nonSchedulued = File('${docDir.path}/tab_3_non_scheduled.json');

    // Create them
    await scheduled.create();
    await nonSchedulued.create();

    if ((await scheduled.readAsString()).isEmpty) {
      await scheduled.writeAsString("{}");
    }

    if ((await nonSchedulued.readAsString()).isEmpty) {
      await nonSchedulued.writeAsString("[]");
    }

    files[3] = [
      scheduled,
      nonSchedulued,
      files[3]!.last,
    ];

    for (int i in [2, 6, 7]) {
      files[i] = [
        ...files[i]!,
        File('${docDir.path}/tab_${i}_current_activities.json')
      ];
    }

    // Today's Tasks file
    File tasksToday = File('${docDir.path}/tasks_today.json');
    await tasksToday.create();

    if ((await tasksToday.readAsString()).isEmpty) {
      await tasksToday.writeAsString("{}");
    }

    File tasksTodayCompleted =
        File('${docDir.path}/tasks_today_completed.json');
    await tasksTodayCompleted.create();
    if ((await tasksTodayCompleted.readAsString()).isEmpty) {
      await tasksTodayCompleted.writeAsString("{}");
    }
    files[0] = [
      tasksToday,
      tasksTodayCompleted,
    ];

    return files;
  },
);

class TabIndex extends StateNotifier<int> {
  TabIndex() : super(12);

  void setIndex(int index) {
    state = index;
  }
}

final tabIndexProvider =
    StateNotifierProvider<TabIndex, int>((ref) => TabIndex());

final tabIcons = [
  tab1Icon,
  tab2Icon,
  tab3Icon,
  tab4Icon,
  tab5Icon,
  tab6Icon,
  tab7Icon,
  tab8Icon,
  tab9Icon,
  tab10Icon,
  tab11Icon,
];

final List tabs = [
  const Tab1HistoryView(),
  const Tab2OutputPage(),
  const Tab3OutputPage(),
  const Tab5OutputPage(),
  const Tab6OutputPage(),
  const CompletedTasksPage(),
  const WorkInProgressPage(),
  const WorkInProgressPage(),
  const WorkInProgressPage(),
  const WorkInProgressPage(),
  const WorkInProgressPage(),
  const WorkInProgressPage(),
  const LaunchScreen(),
];

final List tabInputScreens = [
  const Tab2InputPage(),
  const Tab3InputPage(),
  const Tab5InputPage(),
  const Tab6InputPage(),
];
