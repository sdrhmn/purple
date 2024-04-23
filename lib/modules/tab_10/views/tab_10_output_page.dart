import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_10/views/tab_10_input_page.dart';
import 'package:timely/modules/tab_10/views/tab_10_output_template.dart';
import 'package:timely/modules/tab_10/controllers/input_controller.dart';
import 'package:timely/modules/tab_10/controllers/output_controller.dart';
import 'package:timely/modules/tab_10/models/tab_10_model.dart';
import 'package:timely/reusables.dart';

class Tab10OutputPage extends ConsumerStatefulWidget {
  const Tab10OutputPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _Tab10OutputPageState();
}

class _Tab10OutputPageState extends ConsumerState<Tab10OutputPage> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(tab10OutputProvider);
    final controller = ref.watch(tab10OutputProvider.notifier);

    return provider.when(
      data: (models) {
        return Tab10OutputTemplate(
          models: models,
          onDismissed: (direction, index) {
            Tab10Model model = models[index];

            if (direction == DismissDirection.startToEnd) {
              controller.deleteModel(model);
              models.removeWhere((element) => element.uuid == model.uuid);
              setState(() {});
            } else {
              models.removeWhere((e) => e.uuid == model.uuid);
              setState(() {});
            }
          },
          onTap: (index) {
            ref.read(tab10InputProvider.notifier).setModel(models[index]);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: const Tab10InputPage(),
                  );
                },
              ),
            );
          },
          onPressedHome: () => ref.read(tabIndexProvider.notifier).setIndex(12),
          onPressedAdd: () {
            ref.invalidate(tab10InputProvider);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: const Tab10InputPage(),
                  );
                },
              ),
            );
          },
        );
      },
      error: (_, __) => const Text("ERROR"),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
