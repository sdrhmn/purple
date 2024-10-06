import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/diary/diary_model.dart';

class DiaryForm extends StatefulWidget {
  final Function(DiaryModel memory) onSubmit;
  final DiaryModel? diary;

  const DiaryForm({
    super.key,
    required this.onSubmit,
    this.diary,
  });

  @override
  State<DiaryForm> createState() => _DiaryFormState();
}

class _DiaryFormState extends State<DiaryForm> {
  final _formKey = GlobalKey<FormState>();
  late DiaryModel diary;
  int? _selectedImportance;
  String? _selectedType;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    diary = widget.diary ??
        DiaryModel(
          date: DateTime.now(),
          place: "",
          title: "",
          description: "",
          type: "",
          importance: -1,
        );
    _selectedType = diary.type;
    _selectedImportance = diary.importance;
    _selectedDate = diary.date;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          // Date and Place Fields Side by Side
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      onTapOutside: (e) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      controller: TextEditingController(
                          text: _selectedDate != null
                              ? DateFormat("dd MMM").format(_selectedDate!)
                              : ''),
                      decoration: InputDecoration(
                        hintText: "Date",
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[850],
                      ),
                      readOnly: true,
                      validator: (value) {
                        if (_selectedDate == null) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  onTapOutside: (e) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  textCapitalization: TextCapitalization.sentences,
                  initialValue: diary.place,
                  decoration: InputDecoration(
                    hintText: "Place",
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[850],
                  ),
                  onSaved: (value) => diary.place = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a place';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          TextFormField(
            onTapOutside: (e) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            textCapitalization: TextCapitalization.sentences,
            initialValue: diary.title,
            decoration: InputDecoration(
              hintText: "Title",
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[850],
            ),
            onSaved: (value) => diary.title = value!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          TextFormField(
            onTapOutside: (e) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            textCapitalization: TextCapitalization.sentences,
            maxLines: 6,
            initialValue: diary.description,
            decoration: InputDecoration(
              hintText: "Description",
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[850],
            ),
            onSaved: (value) => diary.description = value!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showTypePicker(),
                  child: AbsorbPointer(
                    child: TextFormField(
                      onTapOutside: (e) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      controller:
                          TextEditingController(text: _selectedType ?? ''),
                      decoration: InputDecoration(
                        hintText: "Type",
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[850],
                      ),
                      readOnly: true,
                      onSaved: (value) => diary.type = _selectedType ?? '',
                      validator: (value) {
                        if (_selectedType == null || _selectedType!.isEmpty) {
                          return 'Please select a type';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showImportancePicker(),
                  child: AbsorbPointer(
                    child: TextFormField(
                      onTapOutside: (e) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      controller: TextEditingController(
                          text: _selectedImportance != -1
                              ? _selectedImportance.toString()
                              : ''),
                      decoration: InputDecoration(
                        hintText: "Importance",
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[850],
                      ),
                      readOnly: true,
                      onSaved: (value) =>
                          diary.importance = _selectedImportance ?? 0,
                      validator: (value) {
                        if (_selectedImportance == null) {
                          return 'Please select an importance level';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onSubmit(diary);
              }
            },
            child: const Text('Submit'),
          ),
        ].map((e) => e.padding(all: 5)).toList(),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _showImportancePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Select Importance'),
        actions: List.generate(
          3,
          (index) => CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedImportance = index + 1;
              });
              Navigator.of(context).pop();
            },
            child: Text((index + 1).toString()),
          ),
        ),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          isDestructiveAction: true,
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showTypePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Select Type'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedType = 'Memoir';
              });
              Navigator.of(context).pop();
            },
            child: const Text('Memoir'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedType = 'Learning';
              });
              Navigator.of(context).pop();
            },
            child: const Text('Learning'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedType = 'Story';
              });
              Navigator.of(context).pop();
            },
            child: const Text('Story'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedType = 'Joke';
              });
              Navigator.of(context).pop();
            },
            child: const Text('Joke'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          isDestructiveAction: true,
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}
