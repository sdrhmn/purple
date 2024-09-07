import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/health/health_models.dart';

class HealthTaskForm extends StatefulWidget {
  final Function(HealthTask task) onSubmit;
  final HealthTask? task;

  const HealthTaskForm({
    super.key,
    required this.onSubmit,
    this.task,
  });

  @override
  State<HealthTaskForm> createState() => _HealthTaskFormState();
}

class _HealthTaskFormState extends State<HealthTaskForm> {
  final _formKey = GlobalKey<FormState>();
  late HealthTask _task;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    _task = widget.task ??
        HealthTask(dateTime: DateTime.now(), task: "", update: "update");
    _selectedDateTime = _task.dateTime;
    super.initState();
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
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (selectedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: _task.task,
            decoration: InputDecoration(
              hintText: "Task",
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.purple[800],
            ),
            onSaved: (value) => _task.task = value!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a task';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: _task.update,
            decoration: InputDecoration(
              hintText: "Update",
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.purple[800],
            ),
            onSaved: (value) => _task.update = value!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an update';
              }
              return null;
            },
          ),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: "Date and Time",
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.purple[800],
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _selectDateTime,
              ),
            ),
            controller: TextEditingController(
              text: _selectedDateTime != null
                  ? '${_selectedDateTime!.toLocal().toShortDateString()} ${_selectedDateTime!.toLocal().toShortTimeString()}'
                  : '',
            ),
            onSaved: (value) =>
                _task.dateTime = _selectedDateTime ?? DateTime.now(),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onSubmit(_task);
              }
            },
            child: const Text('Submit'),
          ),
        ].map((e) => e.padding(all: 2)).toList(),
      ),
    );
  }
}

extension DateTimeFormatting on DateTime {
  String toShortDateString() {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  String toShortTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
