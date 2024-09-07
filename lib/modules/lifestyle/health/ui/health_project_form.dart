import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/health/health_models.dart';

class HealthProjectForm extends StatefulWidget {
  final Function(HealthProject project) onSubmit;
  final HealthProject? project; // Optional parameter for editing

  const HealthProjectForm({
    super.key,
    required this.onSubmit,
    this.project,
  });

  @override
  State<HealthProjectForm> createState() => HealthProjectFormState();
}

class HealthProjectFormState extends State<HealthProjectForm> {
  final _formKey = GlobalKey<FormState>();
  late HealthProject project; // Late initialization of the project
  int? _selectedCriticality;

  @override
  void initState() {
    super.initState();
    // If an existing project is supplied, use it. Otherwise, initialize a new one.
    project = widget.project ?? HealthProject(condition: "", criticality: 0);
    _selectedCriticality = project.criticality;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: project.condition,
            decoration: InputDecoration(
              hintText: "Condition",
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.purple[800],
            ),
            onSaved: (value) => project.condition = value!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a condition';
              }
              return null;
            },
          ),
          GestureDetector(
            onTap: () => _showCriticalityPicker(),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.purple[800],
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedCriticality != null
                        ? 'Criticality: $_selectedCriticality'
                        : 'Select Criticality',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Return the project with updated or new values
                widget.onSubmit(project);
              }
            },
            child: const Text('Submit'),
          ),
        ].map((e) => e.padding(all: 2)).toList(),
      ),
    );
  }

  void _showCriticalityPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Select Criticality'),
        actions: List.generate(
          10,
          (index) => CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedCriticality = index + 1;
                project.criticality = _selectedCriticality!;
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
}
