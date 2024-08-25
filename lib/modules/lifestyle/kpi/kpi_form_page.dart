import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/common/inputs.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/lifestyle/kpi/kpi_model.dart';
import 'package:timely/modules/lifestyle/kpi/kpi_repository.dart';

class KPIFormPage extends ConsumerStatefulWidget {
  const KPIFormPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KpiFormPageState();
}

class _KpiFormPageState extends ConsumerState<KPIFormPage> {
  KPIModel kpiModel = KPIModel(
    date: DateTime.now(),
    activity: 1,
    sleep: 1,
    bowelMovement: 1,
    weight: 60,
  );

  @override
  Widget build(BuildContext context) {
    List<String> indicators =
        'Activity Level.Sleep.Bowel Movement.Weight'.split(".");
    return Scaffold(
      appBar: AppBar(
        title: const Text("KPI Form"),
      ),
      body: ListView(
        children: [
          ...List.generate(4, (index) {
            return [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    indicators[index],
                    textAlign: TextAlign.center,
                  ).width(100),
                  const Spacer(
                    flex: 1,
                  ),
                  indicators[index] == "Weight"
                      ? TextFormFieldAtom(
                              initialValue: kpiModel.weight.toString(),
                              onChanged: (String value) => kpiModel.weight =
                                  double.parse(
                                      value.isNotEmpty ? value : "0.0"),
                              hintText: "")
                          .expanded()
                      : CupertinoPickerAtom(
                          itemExtent: 50,
                          onSelectedItemChanged: (item) {
                            switch (index) {
                              case 0:
                                kpiModel.activity = item;
                                break;
                              case 1:
                                kpiModel.sleep = item;
                                break;
                              case 2:
                                kpiModel.bowelMovement = item;
                                break;
                            }
                          },
                          elements: "Fair.Good.Poor".split("."),
                          initialItemIndex: kpiModel.values[index],
                          size: const Size(0, 100),
                        ).expanded(flex: 8)
                ],
              ).padding(all: 10),
              TextFormField(
                maxLines: 2,
                onChanged: (value) {
                  kpiModel.comments[index] = value;
                },
                decoration: InputDecoration(
                  hintText: "Comments...",
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.purple[800],
                ),
              ).padding(horizontal: 10)
            ];
          }).expand((i) => i).toList(),
          CancelSubmitRowMolecule(
            onSubmitPressed: () {
              ref.read(kpiRepositoryProvider.notifier).write(kpiModel);
              Navigator.of(context).pop();
            },
            onCancelPressed: () => Navigator.of(context).pop(),
          ).padding(vertical: 30, horizontal: 10),
        ],
      ),
    );
  }
}
