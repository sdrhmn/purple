import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_5/views/tab_5_input_page.dart';
import 'package:timely/modules/tab_5/views/tab_5_output_template.dart';
import 'package:timely/modules/tab_5/controllers/input_controller.dart';
import 'package:timely/modules/tab_5/controllers/output_controller.dart';
import 'package:timely/modules/tab_5/repositories/tab_5_repo.dart';
import 'package:timely/reusables.dart';

class Tab5OutputPage extends ConsumerStatefulWidget {
  const Tab5OutputPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Tab5OutputPageState();
}

class _Tab5OutputPageState extends ConsumerState<Tab5OutputPage> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(tab5OutputProvider);

    return provider.when(
        data: (models) {
          return Tab5OutputTemplate(
            models: models,
            onDismissed: (direction, index) {
              if (direction == DismissDirection.startToEnd) {
                ref
                    .read(tab5RepositoryProvider.notifier)
                    .deleteModel(models[index]);
                models.removeWhere(
                    (element) => element.date == models[index].date);
                setState(() {});
              } else {
                ref
                    .read(tab5RepositoryProvider.notifier)
                    .markModelAsComplete(models[index]);
                models.removeWhere((e) => e.date == models[index].date);
                setState(() {});
              }
            },
            onTap: (index) {
              ref.read(tab5InputProvider.notifier).setModel(models[index]);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(),
                      body: const Tab5InputPage(),
                    );
                  },
                ),
              );
            },
            onPressedHome: () =>
                ref.read(tabIndexProvider.notifier).setIndex(12),
            onPressedAdd: () {
              ref.invalidate(tab5InputProvider);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(),
                      body: const Tab5InputPage(),
                    );
                  },
                ),
              );
            },
          );
        },
        error: (_, __) => const Text("ERROR"),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
