import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_8/views/tab_8_input_page.dart';
import 'package:timely/modules/tab_8/views/tab_8_output_template.dart';
import 'package:timely/modules/tab_8/controllers/input_controller.dart';
import 'package:timely/modules/tab_8/controllers/output_controller.dart';
import 'package:timely/reusables.dart';

class Tab8OutputPage extends ConsumerStatefulWidget {
  const Tab8OutputPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Tab8OutputPageState();
}

class _Tab8OutputPageState extends ConsumerState<Tab8OutputPage> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(tab8OutputProvider);
    final controller = ref.read(tab8OutputProvider.notifier);

    return provider.when(
      data: (models) {
        return Tab8OutputTemplate(
          models: models,
          onDismissed: (direction, model) {
            if (direction == DismissDirection.startToEnd) {
              controller.deleteModel(model);
              models.removeWhere((element) => element.uuid == model.uuid);
              setState(() {});
            } else {
              models.removeWhere((e) => e.uuid == model.uuid);
              setState(() {});
            }
          },
          onTap: (model) {
            ref.read(tab8InputProvider.notifier).setModel(model);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: const Tab8InputPage(),
                  );
                },
              ),
            );
          },
          onPressedHome: () => ref.read(tabIndexProvider.notifier).setIndex(12),
          onPressedAdd: () {
            ref.invalidate(tab8InputProvider);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Scaffold(
                appBar: AppBar(),
                body: const Tab8InputPage(),
              );
            }));
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
