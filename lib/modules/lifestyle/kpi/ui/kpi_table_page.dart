import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/kpi/kpi_model.dart';
import 'package:timely/modules/lifestyle/kpi/ui/kpi_form_page.dart';
import 'package:timely/modules/lifestyle/kpi/data/kpi_models_provider.dart';
import 'package:timely/modules/lifestyle/kpi/data/kpi_repository.dart';
import 'package:timely/modules/lifestyle/kpi/ui/kpi_tile.dart';

class KPITablePage extends ConsumerWidget {
  const KPITablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerOfKPIModels = ref.watch(kpiModelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('KPI Table'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const KPIFormPage();
          }));
        },
      ),
      body: providerOfKPIModels.when(
        data: (kpiModels) {
          return ListView.builder(
            itemCount: kpiModels.length,
            itemBuilder: (context, index) {
              final kpi = kpiModels[index];
              return KPITile(
                kpi: kpi,
                onDelete: (kpi) =>
                    _deleteKPI(ref, kpi.id), // Pass ID for deletion
                onEdit: (kpi) => _editKPI(context, ref, kpi), // Edit callback
              ).padding(bottom: 10);
            },
          );
        },
        error: (_, __) => Text("Error $_, $__"),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }

  void _editKPI(BuildContext context, WidgetRef ref, KPIModel kpi) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => KPIFormPage(kpiModel: kpi),
      ),
    );
  }

  void _deleteKPI(WidgetRef ref, int id) async {
    await ref.read(kpiRepositoryProvider.notifier).delete(id);
    // Refresh the KPI list after deletion (using invalidate)
    ref.invalidate(kpiModelsProvider);
  }
}
