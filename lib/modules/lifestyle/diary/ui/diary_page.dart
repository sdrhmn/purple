import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/diary/data/diaries_provider.dart';
import 'package:timely/modules/lifestyle/diary/data/diary_repository.dart';
import 'package:timely/modules/lifestyle/diary/diary_model.dart';
import 'package:timely/modules/lifestyle/diary/ui/diary_form.dart';
import 'diary_tile.dart';

class DiaryPage extends ConsumerStatefulWidget {
  const DiaryPage({super.key});

  @override
  ConsumerState<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends ConsumerState<DiaryPage> {
  String? selectedType;
  int? selectedImportance;

  @override
  Widget build(BuildContext context) {
    final diariesAsyncValue = ref.watch(diariesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diaries'),
      ),
      body: Column(
        children: [
          _buildFilters(), // Add the filters here
          Expanded(
            child: diariesAsyncValue.when(
              data: (diaries) {
                // Filter diaries based on selected type and importance
                final filteredDiaries = diaries.where((diary) {
                  final typeMatches =
                      selectedType == null || diary.type == selectedType;
                  final importanceMatches = selectedImportance == null ||
                      diary.importance == selectedImportance;
                  return typeMatches && importanceMatches;
                }).toList();

                return filteredDiaries.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredDiaries.length,
                        itemBuilder: (context, index) {
                          final diary = filteredDiaries[index];
                          return DiaryTile(
                            diary: diary,
                            onTap: (selectedDiary) =>
                                _editDiary(context, ref, selectedDiary),
                            onDelete: (deletedDiary) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Diary Entry'),
                                  content: const Text(
                                      'Are you sure you want to delete this diary entry?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Perform the delete action
                                        ref
                                            .read(diaryRepositoryProvider
                                                .notifier)
                                            .deleteDiary(diary.id);
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context)
                                          .pop(), // Close the dialog without action
                                      child: const Text('No'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      )
                    : const Center(child: Text('No diaries found'));
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return Scaffold(
                appBar: AppBar(),
                body: DiaryForm(onSubmit: (diary) {
                  ref
                      .read(diaryRepositoryProvider.notifier)
                      .createOrUpdateDiary(diary);
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

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: selectedType,
                  items: <String>['Memoir', 'Learning', 'Story', 'Joke']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedType = newValue;
                    });
                  },
                  isExpanded: true,
                  underline: Container(
                    height: 1,
                    color: Colors.white54, // Change this to match your theme
                  ),
                  style: TextStyle(
                    color: selectedType == null
                        ? Colors.white54
                        : Colors.white, // Text color
                  ),
                  hint: null, // No hint
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButton<int>(
                  value: selectedImportance,
                  items: <int>[1, 2, 3].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedImportance = newValue;
                    });
                  },
                  isExpanded: true,
                  underline: Container(
                    height: 1,
                    color: Colors.white54, // Change this to match your theme
                  ),
                  style: TextStyle(
                    color: selectedImportance == null
                        ? Colors.white54
                        : Colors.white, // Text color
                  ),
                  hint: null, // No hint
                ),
              ),
            ],
          ),
          const SizedBox(
              height: 8), // Spacing between the dropdowns and reset button
          TextButton(
            onPressed: () {
              // Reset the filters
              setState(() {
                selectedType = null;
                selectedImportance = null;
              });
            },
            child: const Text(
              'Reset Filters',
              style: TextStyle(color: Colors.blue), // Theme the button
            ),
          ),
        ],
      ),
    );
  }

  void _editDiary(BuildContext context, WidgetRef ref, DiaryModel diary) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Diary'),
          ),
          body: DiaryForm(
            diary: diary,
            onSubmit: (updatedDiary) {
              ref
                  .read(diaryRepositoryProvider.notifier)
                  .createOrUpdateDiary(updatedDiary);
              Navigator.of(context).pop();
            },
          ),
        );
      }),
    );
  }
}
