import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/controls/data/controls_repository.dart';
import 'package:timely/modules/lifestyle/controls/data/controls_models_provider.dart';
import 'package:timely/modules/lifestyle/controls/controls_model.dart';
import 'package:timely/modules/lifestyle/controls/ui/controls_form_page.dart';

class ControlsTablePage extends ConsumerWidget {
  const ControlsTablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> headers = "Date.Controls.Comments.".split(".");
    final providerOfControlsModels = ref.watch(controlsModelsProvider);

    return providerOfControlsModels.when(
      data: (controlsModels) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Controls Table"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return const ControlsFormPage();
            })),
            child: const Icon(Icons.add),
          ),
          body: SizedBox.expand(
            child: SingleChildScrollView(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FixedColumnWidth(50),
                  3: FlexColumnWidth(0.4)
                },
                border: TableBorder.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
                children: [
                  TableRow(
                    children: List.generate(headers.length, (index) {
                      return Text(headers[index]).padding(all: 5).center();
                    }),
                  ),
                  ...List.generate(controlsModels.length, (i) {
                    final control = controlsModels[i];
                    return TableRow(
                      children: [
                        Text(DateFormat(DateFormat.DAY).format(control.date))
                            .padding(all: 5)
                            .center(),
                        Table(
                          border: TableBorder.all(
                            color: Colors.grey,
                            width: 0.25,
                          ),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(4),
                          },
                          children: [
                            ...List.generate(control.values.length, (j) {
                              return TableRow(
                                children: [
                                  Text(
                                    ["Communication", "Food", "Spending"][j],
                                    overflow: TextOverflow.ellipsis,
                                  ).fontSize(15).padding(all: 5),
                                  Text(control.values[j].toString())
                                      .fontSize(15)
                                      .padding(all: 5)
                                      .center(),
                                ],
                              );
                            }),
                          ],
                        ),
                        Text(control.comments).padding(all: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _editControl(context, ref, control),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteControl(ref, control.id),
                            ),
                          ],
                        ).padding(all: 5),
                      ],
                    );
                  }),
                ],
              ).padding(all: 10),
            ),
          ),
        );
      },
      error: (_, __) => Text("Error: $_, $__"),
      loading: () => const CircularProgressIndicator(),
    );
  }

  void _editControl(
      BuildContext context, WidgetRef ref, ControlsModel control) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ControlsFormPage(
          control: control,
        ),
      ),
    );
  }

  void _deleteControl(WidgetRef ref, int id) async {
    await ref.read(controlsRepositoryProvider.notifier).delete(id);
    ref.invalidate(controlsModelsProvider); // Refresh the list after deletion
  }
}
