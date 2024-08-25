import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/app_startup_provider.dart';
import 'package:timely/common/splash.dart';
import 'package:timely/modules/tasks/ui/screens/completed_task_screen.dart';
import 'package:timely/modules/tasks/ui/screens/todays_tasks_and_lifestyle_screen.dart';
import 'package:timely/modules/tasks/ui/screens/upcoming_task_screen.dart';

class PurpleTimeHomePage extends ConsumerStatefulWidget {
  const PurpleTimeHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<PurpleTimeHomePage> {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      const TodaysScreen(),
      const UpcomingTaskScreen(),
      const CompletedTaskScreen(),
    ];

    final appStartup = ref.watch(appStartupProvider);

    return appStartup.when(
      data: (_) {
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                const Text("PurpleTime")
                    .fontWeight(FontWeight.w300)
                    .fontSize(20)
                    .center()
                    .padding(vertical: 20),
                SizedBox(
                  height: 50,
                  child: TextButton.icon(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor: WidgetStatePropertyAll(pageIndex == 0
                          ? Colors.purple[500]
                          : Colors.purple[700]),
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        pageIndex = 0;
                      });
                    },
                    icon: const Icon(Icons.today_rounded),
                    label: const Text("Home"),
                  ),
                ).padding(horizontal: 10),
                Container().height(10),
                SizedBox(
                  height: 50,
                  child: TextButton.icon(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor: WidgetStatePropertyAll(pageIndex == 1
                          ? Colors.purple[500]
                          : Colors.purple[700]),
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        pageIndex = 1;
                      });
                    },
                    icon: const Icon(Icons.upcoming_rounded),
                    label: const Text("Upcoming"),
                  ),
                ).padding(horizontal: 10),
                Container().height(10),
                SizedBox(
                  height: 50,
                  child: TextButton.icon(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor: WidgetStatePropertyAll(pageIndex == 2
                          ? Colors.purple[500]
                          : Colors.purple[700]),
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        pageIndex = 2;
                      });
                    },
                    icon: const Icon(Icons.done_outline_rounded),
                    label: const Text("Completed"),
                  ),
                ).padding(horizontal: 10),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("PurpleTime"),
          ),
          body: pages[pageIndex],
        );
      },
      error: (_, __) {
        return Text("Error: $_ $__");
      },
      loading: () {
        return const Center(child: SplashScreen());
      },
    );
  }
}
