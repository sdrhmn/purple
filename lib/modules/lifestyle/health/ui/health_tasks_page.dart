import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/health/data/health_providers.dart';
import 'package:timely/modules/lifestyle/health/data/health_repository.dart';
import 'package:timely/modules/lifestyle/health/health_models.dart';
import 'package:timely/modules/lifestyle/health/ui/health_project_form.dart';
import 'package:timely/modules/lifestyle/health/ui/health_task_form.dart';
import 'package:timely/modules/lifestyle/health/ui/tiles/health_task_tile.dart';

class HealthProjectTasksPage extends ConsumerStatefulWidget {
  final HealthProject project;
  final VoidCallback onEdit;

  const HealthProjectTasksPage(
    this.project, {
    super.key,
    required this.onEdit,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HealthProjectTasksPageState createState() => _HealthProjectTasksPageState();
}

class _HealthProjectTasksPageState
    extends ConsumerState<HealthProjectTasksPage> {
  late HealthProject project;

  @override
  void initState() {
    project = widget.project;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the healthTasksProvider for this project
    final healthTasksAsyncValue = ref.watch(healthTasksProvider(project.id));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HealthTaskForm(
                onSubmit: (task) async {
                  await ref
                      .read(healthRepositoryProvider.notifier)
                      .writeHealthTask(task, project);
                  ref.invalidate(healthTasksProvider(project
                      .id)); // Invalidate the tasks provider for the project
                },
              );
            }));
          }),
      appBar: AppBar(
        title: Text('Tasks for ${project.condition}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Open form to edit the project
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HealthProjectEditForm(
                    project: project,
                    onSubmit: (updatedProject) async {
                      await ref
                          .read(healthRepositoryProvider.notifier)
                          .writeHealthProject(updatedProject);

                      setState(() {
                        project = updatedProject;
                      });

                      ref.invalidate(healthProjectsProvider);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: healthTasksAsyncValue.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                "No tasks here... start creating...",
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return HealthTaskTile(
                task: task,
                onDelete: () async {
                  final repository =
                      ref.read(healthRepositoryProvider.notifier);
                  await repository.deleteHealthTask(task); // Delete the task
                  ref.invalidate(healthTasksProvider(project
                      .id)); // Invalidate the tasks provider for the project
                },
                onEdit: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HealthTaskForm(
                        initialTask: task, // Pass the current task for editing
                        onSubmit: (updatedTask) async {
                          // Use the repository's writeHealthTask method to update the task
                          await ref
                              .read(healthRepositoryProvider.notifier)
                              .writeHealthTask(updatedTask, project);
                          ref.invalidate(healthTasksProvider(project
                              .id)); // Invalidate to fetch the updated tasks
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
