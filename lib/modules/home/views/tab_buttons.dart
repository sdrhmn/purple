import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/modules/home/views/launch_screen.dart';
import 'package:timely/modules/home/views/work_in_progress.dart';
import 'package:timely/modules/tab_1_new/history_view.dart';
import 'package:timely/modules/tab_2/pages/tab_2_output_page.dart';
import 'package:timely/modules/tab_3/views/tab_3_output_page.dart';
import 'package:timely/modules/tab_5/views/tab_5_output_page.dart';
import 'package:timely/modules/tab_6/pages/tab_6_output_page.dart';
import 'package:timely/reusables.dart';
import 'package:timely/values.dart';

final List tabs = [
  const Tab1HistoryView(),
  const Tab2OutputPage(),
  const Tab3OutputPage(),
  const Tab5OutputPage(),
  const Tab6OutputPage(),
  const WorkInProgressPage(),
  const WorkInProgressPage(),
  const WorkInProgressPage(),
  const WorkInProgressPage(),
  const WorkInProgressPage(),
  const WorkInProgressPage(),
  const WorkInProgressPage(),
  const LaunchScreen(),
];

class TabButtons extends ConsumerStatefulWidget {
  const TabButtons({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TabButtonsState();
}

class _TabButtonsState extends ConsumerState<TabButtons> {
  final tabIcons = [
    tab1Icon,
    tab2Icon,
    tab3Icon,
    tab4Icon,
    tab5Icon,
    tab6Icon,
    tab7Icon,
    tab8Icon,
    tab9Icon,
    tab10Icon,
    tab11Icon,
  ];

  @override
  Widget build(BuildContext context) {
    int selectedIndex = ref.watch(tabIndexProvider);
    return SizedBox(
      width: 50,
      child: Column(
        children: [
          for (int i in Iterable.generate(11))
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: FloatingActionButton(
                  backgroundColor: i != selectedIndex
                      ? bgTabButtonColor
                      : Colors.indigo, // Add color for selected Tab
                  shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.black38, width: 0.1),
                  ),
                  heroTag: null,
                  onPressed: () {
                    ref.read(tabIndexProvider.notifier).setIndex(i);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.p_8 / 2),
                    child: tabIcons[i],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
