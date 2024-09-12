import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/kpi/kpi_model.dart';
import 'package:timely/modules/lifestyle/kpi/ui/kpi_form_page.dart';
import 'package:timely/modules/lifestyle/kpi/data/kpi_models_provider.dart';
import 'package:timely/modules/lifestyle/kpi/data/kpi_repository.dart';

class KPITablePage extends ConsumerWidget {
  const KPITablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> headers = "Date.Indicators.Comments.".split(".");
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
                columnWidths: const {
                  0: FixedColumnWidth(50),
                  3: FlexColumnWidth(0.4)
                },
                border: TableBorder.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
                children: [
                  TableRow(children: [
                    Text(headers[0]).padding(all: 5).center(),
                    Text(headers[1]).padding(all: 5).center(),
                    Text(headers[2]).padding(all: 5).center(),
                    Text(headers[3]).padding(all: 5).center(),
                  ]),
                  ...List.generate(kpiModels.length, (i) {
                    final kpi = kpiModels[i];
                    return TableRow(
                      children: [
                        Text(DateFormat(DateFormat.DAY).format(kpi.date))
                            .padding(all: 5)
                            .center(),
                        Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          border: TableBorder.all(
                            color: Colors.grey,
                            width: 0.25,
                          ),
                          children: [
                            _buildTableRow('Activity', kpi.activity),
                            _buildTableRow('Sleep', kpi.sleep),
                            _buildTableRow('Bowel', kpi.bowelMovement),
                            _buildTableRow('Weight', kpi.weight),
                          ],
                        ),
                        Text(kpi.comments).padding(all: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editKPI(context, ref, kpi),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteKPI(ref, kpi.id),
                            ),
                          ],
                        ),
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

  TableRow _buildTableRow(String label, dynamic value) {
    return TableRow(children: [
      Text(label, overflow: TextOverflow.ellipsis).fontSize(15).padding(all: 5),
      Center(
        child: Text(value.toString()).fontSize(15).padding(all: 5),
      ),
    ]);
  }

  void _editKPI(BuildContext context, WidgetRef ref, KPIModel kpi) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => KPIFormPage(kpiModel: kpi),
      ),
    );
  }

  void _deleteKPI(WidgetRef ref, int id) async {
    await ref.read(kpiRepositoryProvider.notifier).delete(id);
    ref.invalidate(kpiModelsProvider); // Refresh the KPI list
  }
}
