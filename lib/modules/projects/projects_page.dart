import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/projects/project_form.dart';
import 'package:timely/modules/projects/project_model.dart';
import 'package:timely/modules/projects/project_page.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

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
    Store store = ref.read(storeProvider).requireValue;
    Box<Project> box = store.box<Project>();

    List<Project> projects = box.getAll();

    return Scaffold(
      body: ListView(
        children: [
          ...List.generate(projects.length, (index) {
            return ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 140,
              ),
              child: ListTile(
                onTap: () {
                  context.push(
                    ProjectPage(project: projects[index]),
                    title: projects[index].name,
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                tileColor: Colors.purple.withAlpha(40),
                title: Text(
                  projects[index].name,
                ),
                subtitle: Text(
                  projects[index].description,
                  overflow: TextOverflow.ellipsis,
                ),
              ).padding(all: 10),
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
  }
}
