import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_11/views/tab_11_input_page.dart';
import 'package:timely/modules/tab_11/views/tab_11_output_template.dart';
import 'package:timely/modules/tab_11/controllers/input_controller.dart';
import 'package:timely/modules/tab_11/controllers/output_controller.dart';
import 'package:timely/modules/tab_11/models/tab_11_model.dart';
import 'package:timely/reusables.dart';

class Tab11OutputPage extends ConsumerStatefulWidget {
  const Tab11OutputPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _Tab11OutputPageState();
}

class _Tab11OutputPageState extends ConsumerState<Tab11OutputPage> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(tab11OutputProvider);
    final controller = ref.read(tab11OutputProvider.notifier);

    return provider.when(
      data: (models) {
        return Tab11OutputTemplate(
          models: models,
          onDismissed: (direction, index) {
            Tab11Model model = models[index];

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
            ref.read(tab11InputProvider.notifier).setModel(models[index]);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: const Tab11InputPage(),
                  );
                },
              ),
            );
          },
          onPressedHome: () => ref.read(tabIndexProvider.notifier).setIndex(12),
          onPressedAdd: () {
            ref.invalidate(tab11InputProvider);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: const Tab11InputPage(),
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
