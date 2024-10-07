import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/controls/ui/controls_table_page.dart';
import 'package:timely/modules/lifestyle/goals/ui/goals_page.dart';
import 'package:timely/modules/lifestyle/health/ui/health_projects_page.dart';
import 'package:timely/modules/lifestyle/kpi/ui/kpi_table_page.dart';
import 'package:timely/modules/lifestyle/diary/ui/diary_page.dart';
import 'package:timely/modules/tasks/ui/tabs/lifestyle_status_info_provider.dart';

class LifestyleTab extends ConsumerStatefulWidget {
  const LifestyleTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LifestyleTabState();
}

class _LifestyleTabState extends ConsumerState<LifestyleTab> {
  Future<void> _refreshData() async {
    // Invalidate the provider to refresh its data
    ref.invalidate(lifestyleStatusInfoProvider);
  }

  @override
  Widget build(BuildContext context) {
    List<String> controls =
        'Lifestyle KPI.Main Controls.Health Update.Diary.Goals.Exercise'
            .split(".");
    List<Widget> pages = [
      const KPITablePage(),
      const ControlsTablePage(),
      const HealthProjectsPage(),
      const DiaryPage(),
      const GoalsPage(),
      Container(),
    ];

    List<Widget> icons = [
      Image.asset("assets/LifestyleHome/KPI.png"),
      Image.asset("assets/LifestyleHome/CONTROLS.png"),
      Image.asset("assets/LifestyleHome/HEALTH.png"),
      ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Image.asset("assets/LifestyleHome/DIARY.png"),
      ),
      Image.asset("assets/LifestyleHome/GOALS.png"),
      Container(
        width: 90,
      ),
    ];

    final provider = ref.watch(lifestyleStatusInfoProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: provider.when(
          data: (statusInfoList) {
            return ListView(
              shrinkWrap: true,
              children: [
                ...List.generate(controls.length, (index) {
                  // Get status and last entry for the current component
                  final bool? isUpToDate = index < statusInfoList.length
                      ? statusInfoList[index][0]
                      : null;
                  final DateTime? lastEntry = index < statusInfoList.length
                      ? statusInfoList[index][1]
                      : null;

                  return _buildTile(
                    title: controls[index],
                    icon: icons[index],
                    isUpToDate: isUpToDate,
                    lastEntry: lastEntry,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return pages[index];
                          },
                        ),
                      );
                    },
                  );
                }),
              ]
                  .map((e) => [const SizedBox(height: 2), e])
                  .expand((e) => e)
                  .skip(1)
                  .toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildTile({
    required String title,
    required Widget icon,
    bool? isUpToDate,
    DateTime? lastEntry,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 130,
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
          backgroundColor: WidgetStatePropertyAll(
              Colors.purple[700]!.withBlue((255 * (4 / (5))).round())),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            icon.padding(all: 20),
            const SizedBox(width: 40),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title).fontSize(16),
                  // Display the status and last entry if applicable
                  if (isUpToDate != null) ...[
                    Text(
                      isUpToDate ? "Status: Up-to-date" : "Status: Not updated",
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    if (lastEntry != null)
                      Text(
                        "Last entry: ${formatDateTime(lastEntry)}",
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    ).padding(horizontal: 5);
  }

  String formatDateTime(DateTime dateTime) {
    // Function to format DateTime into the desired format
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}, ${dateTime.day} ${getMonthName(dateTime.month)}';
  }

  String getMonthName(int month) {
    // Helper function to return month name
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }
}
