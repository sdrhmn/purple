import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/kpi/kpi_table_page.dart';

class LifestyleTab extends ConsumerStatefulWidget {
  const LifestyleTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LifestyleTabState();
}

class _LifestyleTabState extends ConsumerState<LifestyleTab> {
  @override
  Widget build(BuildContext context) {
    List<String> controls =
        'Lifestyle KPI.Main Controls.Health.Memory.Goals'.split(".");
    List<Widget> pages = [
      const KPITablePage(),
    ];

    return Scaffold(
      body: Column(
        children: [
          ...List.generate(controls.length, (index) {
            return SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                  backgroundColor: WidgetStatePropertyAll(Colors.purple[700]!
                      .withBlue(
                          (255 * ((4 - index + 4) / (controls.length + 4)))
                              .round())),
                  foregroundColor: const WidgetStatePropertyAll(Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return pages[index];
                      },
                    ),
                  );
                },
                child: Text(controls[index]).fontSize(16),
              ),
            ).padding(horizontal: 5, vertical: 2).expanded();
          }),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {},
      // ),
    );
  }
}
