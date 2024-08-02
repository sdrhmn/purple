import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/app_startup_provider.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/common/splash.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tasks/ui/task_screen.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appStartup = ref.watch(appStartupProvider);

    return appStartup.when(
      data: (_) {
        // :: Debugging ::
        // final store = ref.read(storeProvider).requireValue;
        // final box = store.box<DataTask>();

        return Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("PurpleTime")
              // actions: [
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 10),
              //     child: IconButton.outlined(
              //       onPressed: () {
              //         Navigator.push(context, MaterialPageRoute(
              //           builder: (context) {
              //             return const ReminderView();
              //           },
              //         ));
              //       },
              //       icon: const Icon(Icons.settings),
              //     ),
              //   )
              // ],
              ),
          body: const TaskScreen(),
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
