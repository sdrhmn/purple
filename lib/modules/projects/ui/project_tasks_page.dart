import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/projects/data/project_tasks_provider.dart';
import 'package:timely/modules/projects/ui/project_model.dart';
import 'package:timely/modules/tasks/components/task_tile.dart';
import 'package:timely/modules/tasks/ui/task_form_screen.dart';

class ProjectTasksPage extends ConsumerStatefulWidget {
  final Project project;
  const ProjectTasksPage({super.key, required this.project});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjectPageState();
}

class _ProjectPageState extends ConsumerState<ProjectTasksPage> {
  @override
  Widget build(BuildContext context) {
    Project project = widget.project;
    final providerOfProjectTasks = ref.watch(projectTasksProvider(project.id));

    return providerOfProjectTasks.when(
      data: (tasks) {
        return Scaffold(
          body: ListView(
            children: List.generate(
              tasks.length,
              (index) => TaskTile(
                task: tasks[index],
                onTaskCheckboxChanged: (value) {},
                onSubtaskCheckboxChanged: (value, subTaskIndex) {},
                onDelete: () {},
              ).padding(horizontal: 10, vertical: 10),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text("Add Project Task"),
                      ),
                      body: TaskFormScreen(
                        project: project,
                      ),
                    );
                  },
                ),
              );
            },
            label: const Row(
              children: [
                Icon(
                  Icons.add,
                ),
                Text("Add Task")
              ],
            ),
          ),
        );
      },
      error: (_, __) => Text("ERROR $_, $__"),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
