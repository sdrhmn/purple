import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/modules/tasks/components/task_tile.dart';
import 'package:timely/modules/tasks/task_form_screen.dart';
import 'package:timely/modules/tasks/task_repository.dart';
import 'package:timely/modules/tasks/task_screen.dart';
import 'package:timely/modules/tasks/tasks_provider.dart';

class LaunchScreen extends ConsumerWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 70,
          child: Row(children: [
            Expanded(
              child: Container(
                color: LaunchScreenColors.bgTimer,
              ).clipRRect(all: 10).padding(all: 4),
            ),
            Expanded(
              child: Container(
                child: <Widget>[
                  Text("Filter"),
                  DropdownButton(
                      value: "All",
                      items: [
                        for (String filter in [
                          "All",
                          "Ad-hoc",
                          "Routine",
                          "Exercise"
                        ])
                          DropdownMenuItem(
                            child: Text(filter),
                            value: filter,
                          )
                      ],
                      onChanged: (something) {})
                ].toRow(mainAxisAlignment: MainAxisAlignment.spaceAround),
              ).clipRRect(all: 10).padding(all: 4),
            ),
          ]).padding(horizontal: 2),
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       flex: 2,
        //       child: Container(
        //         color: LaunchScreenColors.bgFMS,
        //         child: const ProgressView(),
        //       ),
        //     ),
        //   ],
        // ),

        Expanded(
          flex: 4,
          child: Consumer(
            builder: (context, ref, child) {
              final providerOfTasks = ref.watch(tasksProvider);

              return providerOfTasks.when(
                  data: (tasks) {
                    return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return TaskTile(
                          task: tasks[index],
                          onCheckboxChanged: (bool? value) {
                            tasks[index].isComplete = value!;
                            ref
                                .read(taskRepositoryProvider.notifier)
                                .updateTask(tasks[index]);
                          },
                          onLongPressed: () {
                            ref
                                .read(taskRepositoryProvider.notifier)
                                .deleteTask(tasks[index]);
                            tasks.removeAt(index);
                          },
                        );
                      },
                      itemCount: tasks.length,
                    ).decorated().padding(all: 7);
                  },
                  error: (_, __) => const Text("ERROR"),
                  loading: () => const CircularProgressIndicator());
            },
          ),
        ),
        Expanded(
          child: Container(),
        ),

        [
          FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.purple[800],
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const TaskScreen(),
            )),
            child: const Text("All"),
          ),
          FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.purple[800],
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  // const TabSelectionScreen(
                  //   navigateToInputScreen: true,
                  // ),
                  const TaskFormScreen(),
            )),
            child: const Icon(Icons.add_rounded),
          ),
        ]
            .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
            .padding(horizontal: 40, bottom: 20),
      ],
    );
  }
}
