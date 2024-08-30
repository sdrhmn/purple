import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/kpi/kpi_form_page.dart';
import 'package:timely/modules/lifestyle/kpi/kpi_models_provider.dart';

class KPITablePage extends ConsumerWidget {
  const KPITablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> headers = "Date.Indicators.Comments".split(".");
    final providerOfKPIModels = ref.watch(kpiModelsProvider);

    return providerOfKPIModels.when(
      data: (kpiModels) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("KPI Table"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return const KPIFormPage();
            })),
            child: const Icon(Icons.add),
          ),
          body: SizedBox.expand(
            child: SingleChildScrollView(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FixedColumnWidth(50),
                },
                border: TableBorder.all(
                  color: Colors.grey,
                ),
                children: [
                  TableRow(children: [
                    Text(headers[0]).padding(all: 5).center(),
                    Text(headers[1]).padding(all: 5).center(),
                    Text(headers[2]).padding(all: 5).center()
                  ]),
                  ...List.generate(kpiModels.length, (i) {
                    return TableRow(
                      children: [
                        Text(DateFormat(DateFormat.DAY)
                                .format(kpiModels[i].date))
                            .padding(all: 5)
                            .center(),
                        Table(
                          children: [
                            TableRow(children: [
                              const Text('Activity').padding(all: 5),
                              Center(
                                child: Text(kpiModels[i].activity.toString())
                                    .padding(all: 5),
                              ),
                            ]),
                            TableRow(children: [
                              const Text('Sleep').padding(all: 5),
                              Center(
                                child: Text(kpiModels[i].sleep.toString())
                                    .padding(all: 5),
                              ),
                            ]),
                            TableRow(
                              children: [
                                const Text('Bowel').padding(all: 5),
                                Center(
                                  child: Text(
                                          kpiModels[i].bowelMovement.toString())
                                      .padding(all: 5),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(kpiModels[i].comments).padding(all: 5),
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
