import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/app_startup_provider.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/common/splash.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tasks/ui/todays_task_screen.dart';
import 'package:timely/modules/tasks/ui/upcoming_tasks_screen.dart';
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
    ];

    final appStartup = ref.watch(appStartupProvider);

    return appStartup.when(
      data: (_) {
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(child: Text("PurpleTime")),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      pageIndex = 0;
                    });
                  },
                  icon: Icon(Icons.today_rounded),
                  label: Text("Today's Tasks"),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                  icon: Icon(Icons.upcoming_rounded),
                  label: Text("Upcoming Tasks"),
                )
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
        return Text("Error: $_");
      },
      loading: () {
        return const Center(child: SplashScreen());
      },
    );
  }
}
