import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/memory/memory_model.dart';

class MemoryForm extends StatefulWidget {
  final Function(MemoryModel memory) onSubmit;
  final MemoryModel? memory;

  const MemoryForm({
    super.key,
    required this.onSubmit,
    this.memory,
  });

  @override
  State<MemoryForm> createState() => _MemoryFormState();
}

class _MemoryFormState extends State<MemoryForm> {
  final _formKey = GlobalKey<FormState>();
  late MemoryModel memory;
  int? _selectedImportance;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    memory = widget.memory ??
        MemoryModel(title: "", detail: "", type: "", importance: 0);
    _selectedType = memory.type;
    _selectedImportance = memory.importance;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: memory.title,
            decoration: InputDecoration(
              hintText: "Title",
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.purple[800],
            ),
            onSaved: (value) => memory.title = value!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: memory.detail,
            decoration: InputDecoration(
              hintText: "Detail",
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.purple[800],
            ),
            onSaved: (value) => memory.detail = value!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a detail';
              }
              return null;
            },
          ),
          GestureDetector(
            onTap: () => _showTypePicker(),
            child: AbsorbPointer(
              child: TextFormField(
                controller: TextEditingController(text: _selectedType ?? ''),
                decoration: InputDecoration(
                  hintText: "Type",
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.purple[800],
                ),
                readOnly: true,
                onSaved: (value) => memory.type = _selectedType ?? '',
                validator: (value) {
                  if (_selectedType == null || _selectedType!.isEmpty) {
                    return 'Please select a type';
                  }
                  return null;
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showImportancePicker(),
            child: AbsorbPointer(
              child: TextFormField(
                controller: TextEditingController(
                    text: _selectedImportance != null
                        ? _selectedImportance.toString()
                        : ''),
                decoration: InputDecoration(
                  hintText: "Importance",
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.purple[800],
                ),
                readOnly: true,
                onSaved: (value) =>
                    memory.importance = _selectedImportance ?? 0,
                validator: (value) {
                  if (_selectedImportance == null) {
                    return 'Please select an importance level';
                  }
                  return null;
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onSubmit(memory);
              }
            },
            child: const Text('Submit'),
          ),
        ].map((e) => e.padding(all: 5)).toList(),
      ),
    );
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
