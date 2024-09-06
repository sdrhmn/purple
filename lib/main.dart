import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/app_startup_provider.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/common/splash.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/projects/projects_page.dart';
import 'package:timely/modules/tasks/ui/task_screens/completed_task_screen.dart';
import 'package:timely/modules/tasks/ui/task_screens/overdue_task_screen.dart';
import 'package:timely/modules/tasks/ui/task_screens/todays_task_screen.dart';
import 'package:timely/modules/tasks/ui/task_screens/upcoming_task_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

// ------ Firebase --------
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotifService().init();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
// ------------------------------

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appDarkTheme,
      themeMode: ThemeMode.dark,
      home: const PurpleTimeHomePage(),
    );
  }
}

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
      const TodaysTaskScreen(),
      const UpcomingTaskScreen(),
      const CompletedTaskScreen(),
      const OverdueTaskScreen(),
      const ProjectsPage()
    ];

    final appStartup = ref.watch(appStartupProvider);

    return appStartup.when(
      data: (_) {
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                const Text("PurpleTime")
                    .letterSpacing(10)
                    .fontWeight(FontWeight.w300)
                    .fontSize(20)
                    .center()
                    .padding(vertical: 20),
                ...List.generate(4, (index) {
                  List<String> items =
                      "Today.Upcoming.Complete.Overdue".split(".");
                  List<IconData> icons = [
                    Icons.today_rounded,
                    Icons.upcoming,
                    Icons.done_all,
                    Icons.calendar_month
                  ];
                  return SizedBox(
                    height: 50,
                    child: TextButton.icon(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        backgroundColor: WidgetStatePropertyAll(
                            pageIndex == index
                                ? Colors.purple[500]
                                : Colors.purple[700]),
                        foregroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          pageIndex = index;
                        });
                      },
                      icon: Icon(icons[index]),
                      label: Text(items[index]),
                    ),
                  ).padding(horizontal: 10);
                })
                    .map((e) => [Container().height(10), e])
                    .expand((e) => e)
                    .skip(1)
                    .toList(),
                const Divider(
                  height: 30,
                  indent: 10,
                  endIndent: 10,
                ),
                SizedBox(
                  height: 50,
                  child: TextButton.icon(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor: WidgetStatePropertyAll(pageIndex == 5 - 1
                          ? Colors.purple[500]
                          : Colors.purple[700]),
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        pageIndex = 5 - 1;
                      });
                    },
                    icon: const Icon(Icons.settings_applications),
                    label: const Text("Projects"),
                  ),
                ).padding(horizontal: 10),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("PurpleTime")
                .letterSpacing(2)
                .fontWeight(FontWeight.w300)
                .fontSize(20),
          ),
          body: pages[pageIndex],
        );
      },
      error: (_, __) {
        return Scaffold(body: Text("Error: $_ $__"));
      },
      loading: () {
        return const Center(child: SplashScreen());
      },
    );
  }
}
