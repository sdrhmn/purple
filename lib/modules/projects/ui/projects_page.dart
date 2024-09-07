import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/projects/data/project_repository.dart';
import 'package:timely/modules/projects/data/projects_provider.dart';
import 'package:timely/modules/projects/ui/project_form.dart';
import 'package:timely/modules/projects/ui/project_tasks_page.dart';

extension on BuildContext {
  push(Widget widget, {String? title}) {
    Navigator.of(this).push(MaterialPageRoute(builder: (ctx) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title ?? ""),
        ),
        body: widget,
      );
    }));
  }
}

class ProjectsPage extends ConsumerStatefulWidget {
  const ProjectsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<ProjectsPage> {
  @override
  Widget build(BuildContext context) {
    final providerOfProjects = ref.watch(projectsProvider);

    return providerOfProjects.when(
      data: (projects) {
        return Scaffold(
          body: ListView(
            children: [
              ...List.generate(projects.length, (index) {
                return Row(
                  children: [
                    Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                context.push(ProjectForm(
                                  project: projects[index],
                                ));
                              },
                              icon: const Icon(
                                Icons.edit,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  ref
                                      .read(projectRepositoryProvider.notifier)
                                      .deleteProject(projects.removeAt(index));
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ListTile(
                      onTap: () {
                        context.push(
                          ProjectTasksPage(project: projects[index]),
                          title: projects[index].name,
                        );
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      tileColor: Colors.purple.withAlpha(40),
                      title: Text(
                        projects[index].name,
                      ).fontSize(25),
                      subtitle: Text(
                        projects[index].description,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ).padding(all: 10).expanded(),
                  ],
                );
              }),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push(const ProjectForm()),
            child: const Icon(
              Icons.add,
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
