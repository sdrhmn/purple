import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/common/buttons.dart';
import 'package:timely/modules/projects/project_model.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

extension on BuildContext {
  pop() {
    Navigator.of(this).pop();
  }
}

class ProjectForm extends ConsumerStatefulWidget {
  const ProjectForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<ProjectForm> {
  Project project = Project(
    name: "",
    description: "",
    duration: Duration.zero,
  );
  List<Task> tasks = [];

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
                    context.pop();

                    Store store = ref.read(storeProvider).requireValue;
                    Box<Project> box = store.box<Project>();

                    box.put(project);
                  });
                },
                text: "Create Project")
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
