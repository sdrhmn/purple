import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/common/inputs.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/lifestyle/controls/controls_model.dart';
import 'package:timely/modules/lifestyle/controls/controls_repository.dart';
import 'package:timely/modules/lifestyle/controls/controls_models_provider.dart';

class ControlsFormPage extends ConsumerStatefulWidget {
  const ControlsFormPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ControlsFormPageState();
}

class _ControlsFormPageState extends ConsumerState<ControlsFormPage> {
  late ControlsModel controlsModel;

  @override
  void initState() {
    DateTime now = DateTime.now();
    controlsModel = ControlsModel(
      date: DateTime(now.year, now.month, now.day),
      communication: 1,
      food: 1,
      spending: 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> indicators = 'Communication.Food.Spending'.split(".");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Controls Form"),
      ),
      body: ListView(
        children: [
          ...List.generate(indicators.length, (index) {
            return [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    indicators[index],
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  CupertinoPickerAtom(
                    itemExtent: 50,
                    onSelectedItemChanged: (item) {
                      switch (index) {
                        case 0:
                          controlsModel.communication = item;
                          break;
                        case 1:
                          controlsModel.food = item;
                          break;
                        case 2:
                          controlsModel.spending = item;
                          break;
                      }
                    },
                    elements: "Fair.Good.Poor".split("."),
                    initialItemIndex: controlsModel.values[index],
                    size: const Size(200, 100),
                  )
                ],
              ).padding(all: 10),
            ];
          }).expand((i) => i).toList(),
          const SizedBox(
            height: 10,
          ),
          // TextFormField(
          //   maxLines: 3,
          //   onChanged: (value) {
          //     controlsModel.comments = value;
          //   },
          //   decoration: InputDecoration(
          //     hintText: "Comments...",
          //     border: const OutlineInputBorder(
          //       borderSide: BorderSide.none,
          //     ),
          //     filled: true,
          //     fillColor: Colors.purple[800],
          //   ),
          // ).padding(horizontal: 10),
          CancelSubmitRowMolecule(
            onSubmitPressed: () async {
              Navigator.of(context).pop();
              await ref
                  .read(controlsRepositoryProvider.notifier)
                  .write(controlsModel);
              ref.invalidate(controlsModelsProvider);
            },
            onCancelPressed: () => Navigator.of(context).pop(),
          ).padding(vertical: 30, horizontal: 10),
        ],
      ),
    );
  }
}
