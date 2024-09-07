import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/common/buttons.dart';
import 'package:timely/modules/projects/data/project_repository.dart';
import 'package:timely/modules/projects/data/projects_provider.dart';
import 'package:timely/modules/projects/ui/project_model.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/reusables.dart';

extension on BuildContext {
  pop() {
    Navigator.of(this).pop();
  }
}

class ProjectForm extends ConsumerStatefulWidget {
  final Project? project;
  const ProjectForm({super.key, this.project});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<ProjectForm> {
  late Project project;
  List<Task> tasks = [];

  @override
  void initState() {
    project = widget.project ??
        Project(
          name: "",
          description: "",
          duration: Duration.zero,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextFormField(
          onTapOutside: (PointerDownEvent event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          maxLines: 3,
          initialValue: project.name,
          decoration: InputDecoration(
            hintText: "Project Name",
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.purple.withAlpha(40),
          ),
          onChanged: (value) {
            project.name = value;
          },
        ),
        TextFormField(
          onTapOutside: (PointerDownEvent event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          maxLines: 5,
          initialValue: project.description,
          decoration: InputDecoration(
            hintText: "Description",
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.purple.withAlpha(20),
          ),
          onChanged: (value) {
            project.description = value;
          },
        ),
        // Row(
        //   children: <Widget>[
        //     CupertinoPickerAtom(
        //       itemExtent: 30,
        //       onSelectedItemChanged: (index) {},
        //       elements: List.generate(
        //         5,
        //         (index) => (index + 1).toString(),
        //       ),
        //       initialItemIndex: project.duration.inDays,
        //       size: const Size(0, 100),
        //     ),
        //   ].map((Widget e) => e.expanded()).toList(),
        // ),
        TextButtonAtom.large(
                onPressed: () {
                  setState(() {
                    ref
                        .read(projectRepositoryProvider.notifier)
                        .writeProject(project)
                        .then((v) {
                      ref.invalidate(projectsProvider);
                    });
                    context.pop();
                  });
                },
                text:
                    widget.project == null ? "Create Project" : "Save Changes")
            .padding(vertical: 5),
      ]
          .map((e) => [
                const SizedBox(height: 10),
                e,
              ])
          .expand((e) => e)
          .toList(),
    ).decorated().padding(horizontal: 10);
  }
}
