import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/memory/data/memories_provider.dart';
import 'package:timely/modules/lifestyle/memory/data/memory_repository.dart';
import 'package:timely/modules/lifestyle/memory/memory_model.dart';
import 'package:timely/modules/lifestyle/memory/ui/memory_form.dart';

class MemoriesPage extends ConsumerStatefulWidget {
  const MemoriesPage({super.key});

  @override
  ConsumerState<MemoriesPage> createState() => _MemoriesPageState();
}

class _MemoriesPageState extends ConsumerState<MemoriesPage> {
  @override
  Widget build(BuildContext context) {
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
                  return Dismissible(
                    key: ValueKey(memory.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              SizedBox(width: 20),
                              Text('Delete',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        return await _confirmDelete(context, memory);
                      }
                      return false;
                    },
                    onDismissed: (direction) {
                      ref
                          .read(memoryRepositoryProvider.notifier)
                          .deleteMemory(memory.id);
                      // Update state after deletion
                      setState(() {});
                    },
                    child: ListTile(
                      title: Text(memory.title),
                      subtitle: Text(memory.detail),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(memory.type,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                              .fontSize(20),
                          const SizedBox(width: 10),
                          Text(memory.importance.toString(),
                                  style: const TextStyle(color: Colors.grey))
                              .fontSize(20),
                        ],
                      ),
                      onTap: () => _editMemory(context, ref, memory),
                    ).padding(all: 8),
                  );
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

  Future<bool> _confirmDelete(BuildContext context, MemoryModel memory) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${memory.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    return result ?? false;
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
}
