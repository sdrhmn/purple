import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/projects/project_model.dart';
import 'package:timely/modules/tasks/components/task_tile.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/modules/tasks/ui/task_form_screen.dart';

class ProjectPage extends ConsumerStatefulWidget {
  final Project project;
  const ProjectPage({super.key, required this.project});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjectPageState();
}

class _ProjectPageState extends ConsumerState<ProjectPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.project.id);
    Project project = widget.project;
    return Scaffold(
      body: ListView(
        children: List.generate(
          project.tasks.length,
          (index) => TaskTile(
            task: Task.fromDataTask(project.tasks[index]),
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
  }
}
