import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_8/views/filter_buttons_molecule.dart';
import 'package:timely/modules/tab_8/models/tab_8_model.dart';

class Tab8OutputTemplate extends ConsumerStatefulWidget {
  final List<Tab8Model> models;
  final void Function(DismissDirection direction, Tab8Model model) onDismissed;
  final void Function(Tab8Model model) onTap;
  final VoidCallback onPressedHome;
  final VoidCallback onPressedAdd;

  const Tab8OutputTemplate({
    super.key,
    required this.models,
    required this.onDismissed,
    required this.onTap,
    required this.onPressedHome,
    required this.onPressedAdd,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _Tab8OutputTemplateState();
}

class _Tab8OutputTemplateState extends ConsumerState<Tab8OutputTemplate> {
  Set<int> lsjSelections = {};
  Set<int> hmlSelections = {};

  @override
  Widget build(BuildContext context) {
    List filteredModels = widget.models.where((model) {
      if (lsjSelections.length + hmlSelections.length == 0) {
        return true;
      } else {
        return hmlSelections.contains(model.hml) &&
            lsjSelections.contains(model.lsj);
      }
    }).toList();

    return Stack(
      children: [
        ListView(
          children: [
            FilterButtonsMolecule(
              lsjSelections: lsjSelections,
              hmlSelections: hmlSelections,
              onLSJSelectionsChanged: (selections) {
                setState(() {
                  lsjSelections = selections;
                });
              },
              onHMLSelectionsChanged: (selections) {
                setState(() {
                  hmlSelections = selections;
                });
              },
            ),
            ...List.generate(
              filteredModels.length,
              (index) {
                Tab8Model model = filteredModels[index];

                return DismissibleEntryRowMolecule(
                  onDismissed: (direction) =>
                      widget.onDismissed(direction, model),
                  child: InkWell(
                    onTap: () => widget.onTap(model),
                    child: Container(
                      color: Colors.indigo,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat(DateFormat.ABBR_MONTH_DAY)
                                      .format(model.date),
                                ),
                                Text(model.title),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Wrap(
                                children: [
                                  Text(model.description),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            height: 0,
                            color: Colors.black,
                            thickness: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        // |--| Navigation Row
        Column(
          children: [
            const Spacer(),
            NavigationRowMolecule(
              onPressedHome: widget.onPressedHome,
              onPressedAdd: widget.onPressedAdd,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        )
      ],
    );
  }
}
