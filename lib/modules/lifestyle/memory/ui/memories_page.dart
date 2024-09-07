import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/memory/data/memories_provider.dart';
import 'package:timely/modules/lifestyle/memory/data/memory_repository.dart';
import 'package:timely/modules/lifestyle/memory/memory_model.dart';
import 'package:timely/modules/lifestyle/memory/ui/memory_form.dart';

class MemoriesPage extends ConsumerWidget {
  const MemoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoriesAsyncValue = ref.watch(memoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memories'),
      ),
      body: memoriesAsyncValue.when(
        data: (memories) => memories.isNotEmpty
            ? ListView.builder(
                itemCount: memories.length,
                itemBuilder: (context, index) {
                  final memory = memories[index];
                  return ListTile(
                    title: Text(memory.title),
                    subtitle: Text(memory.detail),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editMemory(context, ref, memory),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteMemory(context, ref, memory),
                        ),
                      ],
                    ),
                  ).padding(all: 8);
                },
              )
            : const Center(
                child: Text('No memories found'),
              ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return Scaffold(
                appBar: AppBar(),
                body: MemoryForm(onSubmit: (memory) {
                  ref
                      .read(memoryRepositoryProvider.notifier)
                      .createOrUpdateMemory(memory);
                  Navigator.of(context).pop();
                }),
              );
            }),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editMemory(BuildContext context, WidgetRef ref, MemoryModel memory) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Memory'),
          ),
          body: MemoryForm(
            memory: memory,
            onSubmit: (updatedMemory) {
              ref
                  .read(memoryRepositoryProvider.notifier)
                  .createOrUpdateMemory(updatedMemory);
              Navigator.of(context).pop();
            },
          ),
        );
      }),
    );
  }

  void _deleteMemory(BuildContext context, WidgetRef ref, MemoryModel memory) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${memory.title}"?'),
        actions: [
          TextButton(
            onPressed: () {
              ref
                  .read(memoryRepositoryProvider.notifier)
                  .deleteMemory(memory.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
