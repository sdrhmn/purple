import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/kpi/kpi_form_page.dart';
import 'package:timely/modules/lifestyle/kpi/kpi_model.dart';
import 'package:timely/modules/lifestyle/kpi/kpi_repository.dart';

class KPITablePage extends ConsumerWidget {
  const KPITablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> headers = "Date.Activity.Sleep.Bowel.Weight".split(".");
    List<KPIModel> kpiModels =
        ref.read(kpiRepositoryProvider.notifier).getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text("KPI Table"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const KPIFormPage();
        })),
        child: const Icon(Icons.add),
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Table(
            border: TableBorder.all(
              width: 1.0,
              color: Colors.black,
            ),
            children: [
              // Headers
              TableRow(
                  children: List.generate(headers.length, (index) {
                return TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Tooltip(
                      message: headers[index],
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        headers[index],
                        textAlign: TextAlign.center,
                      )
                          .fontWeight(FontWeight.bold)
                          .fontSize(15)
                          .padding(all: 10),
                    ));
              })),
              // Data
              ...List.generate(
                kpiModels.length,
                (i) {
                  return TableRow(
                    decoration: BoxDecoration(
                        color: i % 2 == 0
                            ? Colors.grey.withAlpha(20)
                            : Colors.transparent),
                    children: List.generate(
                      5,
                      (j) {
                        return TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            [
                              DateFormat(DateFormat.ABBR_MONTH_DAY)
                                  .format(kpiModels[i].date),
                              ...kpiModels[i]
                                  .values
                                  .sublist(0, 3)
                                  .map((e) => ["Fair", "Good", "Poor"][e])
                                  .toList(),
                              kpiModels[i].weight.toString(),
                            ][j]
                                .toString(),
                            textAlign: TextAlign.center,
                          ).fontSize(16).padding(all: 5, vertical: 10),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
