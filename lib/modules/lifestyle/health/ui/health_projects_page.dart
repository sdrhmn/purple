import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/lifestyle/health/data/health_providers.dart';
import 'package:timely/modules/lifestyle/health/data/health_repository.dart';
import 'package:timely/modules/lifestyle/health/health_models.dart';
import 'package:timely/modules/lifestyle/health/ui/health_form.dart';
import 'package:timely/modules/lifestyle/health/ui/tiles/health_project_tile.dart'; // Import the HealthProjectTile

class HealthProjectsPage extends ConsumerStatefulWidget {
  const HealthProjectsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HealthProjectsPageState();
}

class _HealthProjectsPageState extends ConsumerState<HealthProjectsPage> {
  List<HealthProject> _projects = [];

  @override
  void initState() {
    super.initState();
  }

  void _addOrUpdateProject(HealthProject project, HealthTask task) async {
    final repository = ref.read(healthRepositoryProvider.notifier);
    project.healthTasks.add(task);

    await repository.writeHealthProject(project);

    ref.invalidate(healthProjectsProvider);
  }

  void _deleteProject(HealthProject project) async {
    final repository = ref.read(healthRepositoryProvider.notifier);
    repository.deleteHealthProject(project);
    setState(() {
      _projects.remove(project);
    });
  }

  Future<void> _promptForNewTask(
      BuildContext context, HealthProject project, WidgetRef ref) async {
    DateTime? selectedDate;
    String? nextTask;
    String? update;
    String formattedDateTime =
        'No date selected'; // Variable to hold formatted date and time

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: const Text('Add Next Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Next Task'),
                  onChanged: (value) => nextTask = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Update'),
                  onChanged: (value) => update = value,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      final time = await showTimePicker(
                        // ignore: use_build_context_synchronously
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        selectedDate = DateTime(
                          selectedDate!.year,
                          selectedDate!.month,
                          selectedDate!.day,
                          time.hour,
                          time.minute,
                        );
                        // Update formattedDateTime with the selected date and time
                        formattedDateTime =
                            DateFormat.yMMMd().add_jm().format(selectedDate!);
                      }
                    }
                    // Trigger a rebuild to show the updated date and time
                    setState(() {});
                  },
                  child: const Text('Select Date & Time'),
                ),
                const SizedBox(height: 10),
                Text(
                  formattedDateTime, // Display the selected date and time
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (nextTask != null &&
                      update != null &&
                      selectedDate != null) {
                    final newTask = HealthTask(
                      dateTime: selectedDate!,
                      task: nextTask!,
                      update: update!,
                    );

                    // Access the repository to save the task
                    final repository =
                        ref.read(healthRepositoryProvider.notifier);
                    await repository.writeHealthTask(newTask, project);

                    setState(() {
                      project.healthTasks
                          .add(newTask); // Add task to the project
                    });
                  }
                  Navigator.of(context).pop();

                  ref.invalidate(healthProjectsProvider);
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectListAsyncValue = ref.watch(healthProjectsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Health Projects')),
      body: projectListAsyncValue.when(
        data: (projects) {
          _projects = projects; // Update projects list
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];

              return Dismissible(
                key: ValueKey(project.id),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade400, Colors.red.shade900],
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                secondaryBackground: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade900],
                    ),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.done, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    await _promptForNewTask(
                        context, project, ref); // Swipe left for new task
                    return false; // Don't dismiss
                  } else if (direction == DismissDirection.startToEnd) {
                    return true; // Swipe right to delete
                  }
                  return false;
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    _deleteProject(project); // Delete the project
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: HealthProjectTile(project: project),
                ), // Use HealthProjectTile here
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new project form
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HealthProjectWithTaskForm(
                onSubmit: (project, task) {
                  _addOrUpdateProject(project, task);
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
