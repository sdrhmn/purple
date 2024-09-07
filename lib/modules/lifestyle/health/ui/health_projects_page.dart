import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/health/data/health_providers.dart';
import 'package:timely/modules/lifestyle/health/data/health_repository.dart';
import 'package:timely/modules/lifestyle/health/ui/health_project_form.dart';
import 'package:timely/modules/lifestyle/health/ui/health_tasks_page.dart';

class HealthProjectsPage extends ConsumerWidget {
  const HealthProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthProjectsAsync = ref.watch(healthProjectsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Health Projects')),
      body: healthProjectsAsync.when(
        data: (projects) {
          if (projects.isEmpty) {
            return const Center(child: Text('No health projects available.'));
          }
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HealthTasksPage(project: project),
                    ),
                  );
                },
                tileColor: Colors.purple[800],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                title: Text(project.condition),
                subtitle: Text('Criticality: ${project.criticality}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                  title: const Text('Edit Health Project')),
                              body: HealthProjectForm(
                                project: project,
                                onSubmit: (updatedProject) {
                                  Navigator.of(context).pop();
                                  ref
                                      .read(healthRepositoryProvider.notifier)
                                      .writeHealthProject(updatedProject)
                                      .then((val) => ref
                                          .invalidate(healthProjectsProvider));
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
                                'Are you sure you want to delete this project?'),
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
                              .deleteHealthProject(project)
                              .then((_) =>
                                  ref.invalidate(healthProjectsProvider));
                        }
                      },
                    ),
                  ],
                ),
              ).padding(all: 2);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(),
                body: HealthProjectForm(
                  onSubmit: (project) {
                    Navigator.of(context).pop();
                    ref
                        .read(healthRepositoryProvider.notifier)
                        .writeHealthProject(project)
                        .then((val) => ref.invalidate(healthProjectsProvider));
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
