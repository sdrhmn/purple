import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/health/data/health_providers.dart';
import 'package:timely/modules/lifestyle/health/data/health_repository.dart';
import 'package:timely/modules/lifestyle/health/health_models.dart';
import 'package:timely/modules/lifestyle/health/ui/health_task_form.dart'; // Adjust as needed

class HealthTasksPage extends ConsumerWidget {
  final HealthProject project; // Required project parameter

  const HealthTasksPage({
    super.key,
    required this.project, // Ensure project is passed
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pass the project.id to the provider
    final healthTasksAsync = ref.watch(healthTasksProvider(project.id));

    return Scaffold(
      appBar: AppBar(title: Text(project.condition)),
      body: healthTasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text('No health tasks available.'));
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.task),
                subtitle: Text('Update: ${task.update}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar:
                                  AppBar(title: const Text('Edit Health Task')),
                              body: HealthTaskForm(
                                task: task,
                                onSubmit: (updatedTask) {
                                  Navigator.of(context).pop();
                                  ref
                                      .read(healthRepositoryProvider.notifier)
                                      .writeHealthTask(updatedTask, project)
                                      .then((_) => ref.invalidate(
                                          healthTasksProvider(project.id)));
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this task?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete ?? false) {
                          await ref
                              .read(healthRepositoryProvider.notifier)
                              .deleteHealthTask(task)
                              .then((_) => ref
                                  .invalidate(healthTasksProvider(project.id)));
                        }
                      },
                    ),
                  ],
                ),
              ).padding(all: 5);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the form page to add a new HealthTask
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Add Health Task')),
                body: HealthTaskForm(
                  onSubmit: (task) {
                    Navigator.of(context).pop();
                    ref
                        .read(healthRepositoryProvider.notifier)
                        .writeHealthTask(task, project)
                        .then((_) =>
                            ref.invalidate(healthTasksProvider(project.id)));
                  },
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
