import 'package:flutter/material.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_11/models/tab_11_model.dart';

class Tab11OutputTemplate extends StatelessWidget {
  final List<Tab11Model> models;
  final void Function(DismissDirection direction, int index) onDismissed;
  final void Function(int index) onTap;
  final VoidCallback onPressedHome;
  final VoidCallback onPressedAdd;

  const Tab11OutputTemplate({
    super.key,
    required this.models,
    required this.onDismissed,
    required this.onTap,
    required this.onPressedHome,
    required this.onPressedAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.p_8),
              child: TextRowMolecule(
                texts: "Item,Quantity".split(","),
                defaultAligned: const [0],
                customWidths: const {1: 100},
              ),
            ),
            ...List.generate(
              models.length,
              (index) {
                Tab11Model model = models[index];

                return InkWell(
                  onTap: () => onTap(index),
                  child: DismissibleEntryRowMolecule(
                    onDismissed: (direction) => onDismissed(direction, index),
                    child: TextRowMolecule(
                      padding: const EdgeInsets.all(AppSizes.p_8),
                      minHeight: 60,
                      texts: [
                        model.item.toString(),
                        model.qty.toString(),
                      ],
                      defaultAligned: const [0],
                      customWidths: const {1: 100},
                      rowColor: Tab11Colors
                          .optionColors[model.urgent == true ? 1 : 0],
                    ),
                  ),
                );
              },
            )
          ],
        ),
        Column(
          children: [
            const Spacer(),
            NavigationRowMolecule(
              onPressedHome: onPressedHome,
              onPressedAdd: onPressedAdd,
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
