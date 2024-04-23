import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/reusables.dart';

class WorkInProgressPage extends ConsumerWidget {
  const WorkInProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        const Center(
          child: Text("Work in Progress..."),
        ),

        // Navigation
        Column(
          children: [
            const Spacer(),
            NavigationRowMolecule(
              onPressedHome: () =>
                  ref.read(tabIndexProvider.notifier).setIndex(12),
              hideAddButton: true,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ],
    );
  }
}
