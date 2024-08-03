import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/tasks/components/filter_bar.dart';
import 'package:timely/modules/tasks/data/upcoming_tasks_provider.dart';
import 'package:timely/modules/tasks/ui/task_form_screen.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';
import '../components/task_tile.dart';

class UpcomingTaskScreen extends ConsumerStatefulWidget {
  const UpcomingTaskScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<UpcomingTaskScreen> {
  int pageIndex = 0;
  late PageController _pageViewController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> filters = ['all', 'routine', 'ad-hoc', 'exercise'];
    final providerOfTasks = ref.watch(upcomingTasksProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(100, 100),
        child: Container(
          color: Colors.black45,
          child: FilterBar(
              selection: filters[pageIndex],
              onSelectionChanged: (sel) {
                pageIndex = filters.indexOf(sel.first.toString());
                _pageViewController.animateToPage(
                  pageIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }),
        ),
      ),
      body: providerOfTasks.when(
        data: (List<Task> tasks) {
          return PageView(
            controller: _pageViewController,
            onPageChanged: (value) {
              setState(() {
                pageIndex = value;
              });
            },
            children: List.generate(4, (i) {
              List<Task> filteredTasks = filters[i] == "all"
                  ? tasks
                  : tasks.where((task) => task.type == filters[i]).toList();

              return RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(Duration.zero, () {
                    ref.invalidate(upcomingTasksProvider);
                  });
                },
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text(DateFormat(DateFormat.ABBR_MONTH_DAY)
                                .format(filteredTasks[index].date!))
                            .textStyle(
                              const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            .padding(all: 5, horizontal: 20)
                            .decorated(
                              color: Colors.purple[700],
                              borderRadius: BorderRadius.circular(5),
                            )
                            .padding(bottom: 10),
                        TaskTile(
                          task: filteredTasks[index],
                          onCheckboxChanged: (bool? value) {
                            setState(() {
                              filteredTasks[index].isComplete = value!;
                              ref
                                  .read(taskRepositoryProvider.notifier)
                                  .completeTask(filteredTasks[index]);
                            });
                          },
                          onLongPressed: () {
                            setState(() {
                              ref
                                  .read(taskRepositoryProvider.notifier)
                                  .deleteTask(filteredTasks[index]);
                              filteredTasks.removeAt(index);
                            });
                          },
                        ),
                      ],
                    );
                  },
                  itemCount: filteredTasks.length,
                ),
              ).padding(all: 10);
            }),
          );
        },
        error: (_, __) {
          return const Text("Error");
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: const Text("Create Task"),
              ),
              body: const TaskFormScreen(),
            ),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
