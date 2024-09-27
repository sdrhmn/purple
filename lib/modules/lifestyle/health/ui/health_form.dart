import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/health/health_models.dart';
import 'package:timely/modules/lifestyle/health/ui/clock.dart';

class HealthProjectWithTaskForm extends StatefulWidget {
  final Function(HealthProject project, HealthTask task) onSubmit;
  final HealthProject? project;

  const HealthProjectWithTaskForm({
    super.key,
    required this.onSubmit,
    this.project,
  });

  @override
  State<HealthProjectWithTaskForm> createState() =>
      HealthProjectWithTaskFormState();
}

class HealthProjectWithTaskFormState extends State<HealthProjectWithTaskForm> {
  final _formKey = GlobalKey<FormState>();
  late HealthProject _project;
  late HealthTask _task;
  int? _selectedCriticality;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _project = widget.project ?? HealthProject(condition: "", criticality: 1);
    _task = HealthTask(
      dateTime: DateTime.now(),
      task: "",
      update: "",
    );
    _selectedCriticality = _project.criticality;
    _selectedDateTime = _task.dateTime;
  }

  Future<void> _selectDateTime() async {
    DateTime initialDate = _selectedDateTime ?? DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => Container(
          height: 250, // Height for date picker
          color: Colors.white,
          child: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    height: 200,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: initialDate,
                      onDateTimeChanged: (DateTime newDateTime) {
                        setState(() {
                          _selectedDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            newDateTime.hour,
                            newDateTime.minute,
                          );
                        });
                      },
                    ),
                  ),
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project with Task'),
        backgroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField(
                hint: "Condition",
                initialValue: _project.condition,
                onSaved: (value) => _project.condition = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a condition';
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: () => _showCriticalityPicker(),
                child: _buildDropdownField(
                  hint: _selectedCriticality != null
                      ? 'Criticality: $_selectedCriticality'
                      : 'Select Criticality',
                ),
              ),
              _buildTextField(
                hint: "Next Task",
                initialValue: _task.task,
                onSaved: (value) => _task.task = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the next task';
                  }
                  return null;
                },
              ),
              _buildTextField(
                hint: "Update",
                initialValue: _task.update,
                maxLines: 3,
                onSaved: (value) => _task.update = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an update';
                  }
                  return null;
                },
              ),
              _buildDateTimeField(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onSubmit(_project, _task);
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text('Submit', style: TextStyle(fontSize: 18)),
              ),
            ].map((e) => e.padding(all: 8)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required String initialValue,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      onTapOutside: (e) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      textCapitalization: TextCapitalization.sentences,
      initialValue: initialValue,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[900],
        hintStyle: const TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white),
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildDropdownField({required String hint}) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(color: Colors.white)),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildDateTimeField() {
    return GestureDetector(
      onTap: _selectDateTime,
      child: AbsorbPointer(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.grey[900],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDateTime != null
                        ? DateFormat.yMMMd().add_jm().format(_selectedDateTime!)
                        : 'Select Date and Time',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedDateTime != null) _buildClockWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildClockWidget() {
    return CustomPaint(
      size: const Size(120, 120),
      painter: ClockPainter(dateTime: _selectedDateTime!),
    );
  }

  void _showCriticalityPicker() {
    // Use a local variable to hold the selected criticality
    int selectedCriticality = _selectedCriticality ?? 0;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250, // Height for the picker
        color: Colors.white,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Container(
                  height: 200,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedCriticality,
                    ),
                    itemExtent: 50.0,
                    onSelectedItemChanged: (int index) {
                      // Update the local variable instead of the project's criticality directly
                      selectedCriticality = index + 1;
                    },
                    children: List<Widget>.generate(5, (index) {
                      return Center(
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () {
                  // Set the project's criticality when the Done button is pressed
                  setState(() {
                    _selectedCriticality = selectedCriticality;
                    _project.criticality = _selectedCriticality!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
