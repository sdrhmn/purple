import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/lifestyle/health/health_models.dart';
import 'package:timely/modules/lifestyle/health/ui/clock.dart'; // Import the clock widget
import 'package:styled_widget/styled_widget.dart';

class HealthTaskForm extends StatefulWidget {
  final HealthTask? initialTask; // Optional initial task for editing
  final Function(HealthTask) onSubmit; // Callback for submitting the form

  const HealthTaskForm({
    Key? key,
    this.initialTask,
    required this.onSubmit,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HealthTaskFormState createState() => _HealthTaskFormState();
}

class _HealthTaskFormState extends State<HealthTaskForm> {
  late String nextTask;
  late String update;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialTask != null) {
      nextTask = widget.initialTask!.task;
      update = widget.initialTask!.update;
      selectedDate = widget.initialTask!.dateTime;
    } else {
      nextTask = '';
      update = '';
    }
  }

  Future<void> _selectDateTime() async {
    DateTime initialDate = this.selectedDate ?? DateTime.now();
    DateTime? selectedDate = (await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    ))
        ?.copyWith(
      hour: DateTime.now().hour,
      minute: DateTime.now().minute,
    );

    if (selectedDate != null) {
      DateTime initialTime = selectedDate;
      DateTime finalSelectedTime = selectedDate;

      await showCupertinoModalPopup(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => Container(
          height: 300, // Height for date picker
          color: Colors.white,
          child: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: initialTime,
                      onDateTimeChanged: (DateTime newTime) {
                        // Update the local finalSelectedTime with the new time
                        finalSelectedTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          newTime.hour,
                          newTime.minute,
                        );
                      },
                    ),
                  ),
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () {
                    // Ensure the state is updated with the selected time
                    setState(() {
                      this.selectedDate = finalSelectedTime;
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
                    selectedDate != null
                        ? DateFormat.yMMMd().add_jm().format(selectedDate!)
                        : 'Select Date and Time',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (selectedDate != null)
              CustomPaint(
                size: const Size(120, 120),
                painter: ClockPainter(dateTime: selectedDate!),
              ), // Add the clock widget here
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialTask != null ? 'Edit Task' : 'New Task'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: 'Next Task',
                onChanged: (value) => nextTask = value,
                initialValue: nextTask,
              ),
              _buildTextField(
                label: 'Update',
                onChanged: (value) => update = value,
                initialValue: update,
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),
              _buildDateTimeField(), // Use the new date/time field
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (nextTask.isNotEmpty &&
                        update.isNotEmpty &&
                        selectedDate != null) {
                      final task = HealthTask(
                        id: widget.initialTask?.id ?? 0,
                        dateTime: selectedDate!,
                        task: nextTask,
                        update: update,
                      );
                      widget.onSubmit(task);
                      Navigator.of(context).pop(); // Close the form
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 18)),
                ),
              ),
            ].map((e) => e.padding(all: 8)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
    required String initialValue,
    int maxLines = 1,
  }) {
    return TextField(
      onTapOutside: (e) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      textCapitalization: TextCapitalization.sentences,
      onChanged: onChanged,
      controller: TextEditingController(text: initialValue),
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[900],
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
