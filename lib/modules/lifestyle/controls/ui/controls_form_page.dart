import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/common/inputs.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/lifestyle/controls/controls_model.dart';
import 'package:timely/modules/lifestyle/controls/data/controls_models_provider.dart';
import 'package:timely/modules/lifestyle/controls/data/controls_repository.dart';

class ControlsFormPage extends ConsumerStatefulWidget {
  final ControlsModel? control;

  const ControlsFormPage({super.key, this.control});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ControlsFormPageState();
}

class _ControlsFormPageState extends ConsumerState<ControlsFormPage> {
  late ControlsModel control;

  @override
  void initState() {
    super.initState();
    if (widget.control != null) {
      control = widget.control!;
    } else {
      DateTime now = DateTime.now();
      control = ControlsModel(
        date: DateTime(now.year, now.month, now.day),
        communication: 1,
        food: 1,
        spending: 1,
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: control.date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != control.date) {
      setState(() {
        control.date = picked;
      });
    }
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
          ListTile(
            title: const Text("Date"),
            subtitle: Text(DateFormat('yyyy-MM-dd').format(control.date)),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ).padding(horizontal: 10),
          ...List.generate(indicators.length, (index) {
            return [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    indicators[index],
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 1),
                  CupertinoPickerAtom(
                    itemExtent: 50,
                    onSelectedItemChanged: (item) {
                      switch (index) {
                        case 0:
                          control.communication = item;
                          break;
                        case 1:
                          control.food = item;
                          break;
                        case 2:
                          control.spending = item;
                          break;
                      }
                    },
                    elements: "Fair.Good.Poor".split("."),
                    initialItemIndex: control.values[index],
                    size: const Size(200, 100),
                  )
                ],
              ).padding(all: 10),
            ];
          }).expand((i) => i).toList(),
          const SizedBox(height: 10),
          TextFormField(
            maxLines: 3,
            initialValue: control.comments,
            onChanged: (value) {
              control.comments = value;
            },
            decoration: InputDecoration(
              hintText: "Comments...",
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.purple[800],
            ),
          ).padding(horizontal: 10),
          CancelSubmitRowMolecule(
            onSubmitPressed: () async {
              Navigator.of(context).pop();
              await ref
                  .read(controlsRepositoryProvider.notifier)
                  .write(control);
              ref.invalidate(controlsModelsProvider);
            },
            onCancelPressed: () => Navigator.of(context).pop(),
          ).padding(vertical: 30, horizontal: 10),
        ],
      ),
    );
  }
}
