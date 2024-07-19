import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/common/scheduling/input_controller.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/modules/home/repositories/tasks_today_repo.dart';
import 'package:timely/modules/home/views/tab_selection_screen.dart';
import 'package:timely/modules/home/views/tasks_today_template.dart';
import 'package:timely/modules/home/providers/external_models_provider.dart';
import 'package:timely/modules/tab_1_new/model_provider.dart';
import 'package:timely/modules/tab_2/controllers/output_controller.dart';
import 'package:timely/modules/tab_2/pages/tab_2_input_page.dart';
import 'package:timely/modules/tab_3/repositories/tab_3_repo.dart';
import 'package:timely/modules/tab_3/views/tab_3_input_page.dart';
import 'package:timely/modules/tab_3/controllers/input_controller.dart';
import 'package:timely/modules/tab_3/controllers/output_controller.dart';
import 'package:timely/modules/tab_3/models/ad_hoc_model.dart';
import 'package:timely/modules/tab_6/controllers/output_controller.dart';
import 'package:timely/modules/tab_6/pages/tab_6_input_page.dart';
import 'package:timely/modules/tab_7/controllers/output_controller.dart';
import 'package:timely/modules/tab_7/pages/tab_7_input_page.dart';

class LaunchScreen extends ConsumerWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tabsData = ref.watch(externalModelsProvider);
    return tabsData.when(
        data: (data) {
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
                      child: Center(
                        child: Consumer(
                          builder: (context, ref, child) {
                            var remTime = ref.watch(progressModelController);

                            return remTime.when(
                              data: (model) {
                                return Text(
                                  model.points.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                );
                              },
                              error: (_, __) => const Text("ERROR"),
                              loading: () => const CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ),
                    ).clipRRect(all: 10).padding(all: 4),
                  ),
                  Expanded(
                    child: Container(
                      color: LaunchScreenColors.bgAlert,
                      child: Center(
                        child: Consumer(
                          builder: (context, ref, child) {
                            var remTime = ref.watch(progressModelController);

                            return remTime.when(
                              data: (model) {
                                return Text(
                                  model.level.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                );
                              },
                              error: (_, __) => const Text("ERROR"),
                              loading: () => const CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ),
                    ).clipRRect(all: 10).padding(all: 4),
                  ),
                ]).padding(horizontal: 8),
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
              const Divider(
                height: 5,
                color: Colors.transparent,
              ),
              Expanded(
                flex: 4,
                child: TasksTodayTemplate(
                  data: data,
                  onDismissed: (dir, model, tabNumber, task) async {
                    if (model is AdHocModel) {
                      if (dir == DismissDirection.startToEnd) {
                        await ref
                            .read(tab3OutputProvider.notifier)
                            .deleteModel(model);
                      } else {
                        await ref
                            .read(tab3RepositoryProvider.notifier)
                            .markComplete(model);

                        if (task != null) {
                          await ref
                              .read(tasksTodayRepositoryProvider.notifier)
                              .markTaskAsComplete(task);
                        }
                      }
                    } else if (model is SchedulingModel) {
                      if (dir == DismissDirection.startToEnd) {
                        if (tabNumber == 2) {
                          ref
                              .read(tab2OutputProvider.notifier)
                              .deleteModel(model);
                        } else if (tabNumber == 6 || tabNumber == 7) {
                          ref
                              .read([
                                tab6OutputProvider.notifier,
                                tab7OutputProvider.notifier
                              ][7 - tabNumber!])
                              .deleteModel(model);
                        }
                      } else {
                        await ref
                            .read(tasksTodayRepositoryProvider.notifier)
                            .markTaskAsComplete(task!);
                      }
                    }
                  },
                  onTap: (model, tabNumber) {
                    if (model is AdHocModel) {
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
                    } else if (model is SchedulingModel) {
                      ref
                          .read(schedulingInputProvider.notifier)
                          .setModel(model);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return Scaffold(
                              body: tabNumber == 2
                                  ? const Tab2InputPage()
                                  : tabNumber == 6
                                      ? const Tab6InputPage()
                                      : const Tab7InputPage(),
                              appBar: AppBar(),
                            );
                          },
                        ),
                      );
                    }
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
                    builder: (context) => const TabSelectionScreen(),
                  )),
                  child: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
                FloatingActionButton(
                  heroTag: null,
                  backgroundColor: Colors.purple[800],
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TabSelectionScreen(
                      navigateToInputScreen: true,
                    ),
                  )),
                  child: const Icon(Icons.add_rounded),
                ),
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  .padding(horizontal: 40, bottom: 20),
            ],
          );
        },
        error: (_, __) => const Text("ERROR"),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
