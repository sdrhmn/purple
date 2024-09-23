import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/controls/data/controls_repository.dart';
import 'package:timely/modules/lifestyle/controls/data/controls_models_provider.dart';
import 'package:timely/modules/lifestyle/controls/controls_model.dart';
import 'package:timely/modules/lifestyle/controls/ui/controls_form_page.dart';
import 'package:timely/modules/lifestyle/controls/ui/controls_tile.dart';

class ControlsTablePage extends ConsumerWidget {
  const ControlsTablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerOfControlsModels = ref.watch(controlsModelsProvider);

    return providerOfControlsModels.when(
      data: (controlsModels) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Controls Table"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return const ControlsFormPage();
            })),
            child: const Icon(Icons.add),
          ),
          body: ListView.builder(
            itemBuilder: (context, index) {
              ControlsModel controls = controlsModels[index];
              return ControlsTile(
                controls: controls,
                onEdit: (controls) => _editControl(context, ref, controls),
                onDelete: (controls) => _deleteControl(ref, controls.id),
              ).padding(bottom: 10);
            },
            itemCount: controlsModels.length,
          ),
        );
      },
      error: (_, __) => Text("Error: $_, $__"),
      loading: () => const CircularProgressIndicator(),
    );
  }

  void _editControl(
      BuildContext context, WidgetRef ref, ControlsModel control) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ControlsFormPage(
          control: control,
        ),
      ),
    );
  }

  void _deleteControl(WidgetRef ref, int id) async {
    await ref.read(controlsRepositoryProvider.notifier).delete(id);
    ref.invalidate(controlsModelsProvider); // Refresh the list after deletion
  }
}
