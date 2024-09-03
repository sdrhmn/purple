import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/controls/controls_form_page.dart';
import 'package:timely/modules/lifestyle/controls/controls_models_provider.dart';

class ControlsTablePage extends ConsumerWidget {
  const ControlsTablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> headers = "Date.Indicators.Comments".split(".");
    final providerOfControolsModels = ref.watch(controlsModelsProvider);

    return providerOfControolsModels.when(
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
                },
                border: TableBorder.all(color: Colors.grey, width: 0.5),
                children: [
                  TableRow(
                      children: List.generate(headers.length, (index) {
                    return Text(headers[index]).padding(all: 5).center();
                  })),
                  ...List.generate(controlsModels.length, (i) {
                    return TableRow(
                      children: [
                        Text(DateFormat(DateFormat.DAY)
                                .format(controlsModels[i].date))
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
                            ...List.generate(controlsModels[i].values.length,
                                (j) {
                              return TableRow(children: [
                                Text(
                                  ["Communication", "Food", "Spending"][j],
                                  overflow: TextOverflow.ellipsis,
                                ).fontSize(15).padding(all: 5),
                                Text(controlsModels[i].values[j].toString())
                                    .fontSize(15)
                                    .padding(all: 5)
                                    .center(),
                              ]);
                            }),
                          ],
                        ),
                        Text(controlsModels[i].comments).padding(all: 5),
                      ],
                    );
                  })
                ],
              ).padding(all: 10),
            ),
          ),
        );
      },
      error: (_, __) => Text("Error $_, $__"),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
