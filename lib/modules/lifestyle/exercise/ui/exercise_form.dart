import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../data/exercise_model.dart';
import 'recurrence_selector.dart'; // Make sure to import your RecurrenceSelector

class ExerciseForm extends StatefulWidget {
  final Exercise? exercise;
  final Function(Exercise exercise) onSubmit;

  const ExerciseForm({
    Key? key,
    this.exercise,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _ExerciseFormState createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  late ExercisePurpose purpose;
  List<List<dynamic>> data = [];
  DateTime? date;
  TimeOfDay? time;
  Duration? duration;
  String? repeats;

  @override
  void initState() {
    super.initState();
    if (widget.exercise != null) {
      purpose = widget.exercise!.purpose;
      data = widget.exercise!.data;
      date = widget.exercise!.date;
      time = TimeOfDay.fromDateTime(widget.exercise!.time);
      duration = widget.exercise!.duration;
      repeats =
          widget.exercise!.repeats.isNotEmpty ? widget.exercise!.repeats : null;
    } else {
      purpose = ExercisePurpose.evaluation;
      addNewRow();
    }
  }

  void addNewRow() {
    setState(() {
      if (purpose == ExercisePurpose.evaluation) {
        data.add(['', '']);
      } else if (purpose == ExercisePurpose.workout) {
        data.add(['', 0, 0]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Physical Fitness')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            shrinkWrap: true,
            children: [
              // Purpose Selection
              Row(
                children: [
                  const Text('Purpose:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<ExercisePurpose>(
                      borderRadius: BorderRadius.circular(10),
                      value: purpose,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            purpose = value;
                            data = [];
                            addNewRow();
                          });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: ExercisePurpose.values.map((purpose) {
                        return DropdownMenuItem(
                          value: purpose,
                          child: Text(
                            purpose == ExercisePurpose.evaluation
                                ? 'Evaluation'
                                : 'Workout',
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Form Fields for Data
              ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller:
                                TextEditingController(text: data[index][0]),
                            decoration: InputDecoration(
                              hintText: 'Element',
                              filled: true,
                              fillColor: Colors.grey[800],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              data[index][0] = value;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (purpose == ExercisePurpose.evaluation)
                          Expanded(
                            child: TextFormField(
                              controller:
                                  TextEditingController(text: data[index][1]),
                              decoration: InputDecoration(
                                hintText: 'Target',
                                filled: true,
                                fillColor: Colors.grey[800],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                data[index][1] = value;
                              },
                            ),
                          )
                        else if (purpose == ExercisePurpose.workout) ...[
                          Expanded(
                            child: TextFormField(
                              controller: TextEditingController(
                                  text: data[index][1].toString()),
                              decoration: InputDecoration(
                                hintText: 'Reps',
                                filled: true,
                                fillColor: Colors.grey[800],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                data[index][1] = int.tryParse(value) ?? 0;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: TextEditingController(
                                  text: data[index][2].toString()),
                              decoration: InputDecoration(
                                hintText: 'Sets',
                                filled: true,
                                fillColor: Colors.grey[800],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                data[index][2] = int.tryParse(value) ?? 0;
                              },
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () {
                            setState(() {
                              data.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.blue),
                onPressed: addNewRow,
              ),
              const SizedBox(height: 20),
              // Date and Time Pickers
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: date ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2999),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            date = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        date != null
                            ? DateFormat("EEE, dd MMM").format(date!)
                            : 'Select Date',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: time ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            time = pickedTime;
                          });
                        }
                      },
                      child: Text(
                        time != null ? time!.format(context) : 'Select Time',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Duration Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Duration', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Switch(
                    value: duration != null,
                    onChanged: (value) {
                      setState(() {
                        duration =
                            value ? const Duration(hours: 0, minutes: 0) : null;
                      });
                    },
                  ),
                  if (duration != null)
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(
                                initialItem: duration!.inHours,
                              ),
                              itemExtent: 32.0,
                              onSelectedItemChanged: (value) {
                                setState(() {
                                  duration = Duration(
                                    hours: value,
                                    minutes: duration!.inMinutes % 60,
                                  );
                                });
                              },
                              children: List<Widget>.generate(
                                24,
                                (index) => Center(child: Text('$index hr')),
                              ),
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(
                                initialItem: duration!.inMinutes % 60,
                              ),
                              itemExtent: 32.0,
                              onSelectedItemChanged: (value) {
                                setState(() {
                                  duration = Duration(
                                    hours: duration!.inHours,
                                    minutes: value,
                                  );
                                });
                              },
                              children: List<Widget>.generate(
                                60,
                                (index) => Center(child: Text('$index min')),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              // Repeats Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Repeats', style: TextStyle(fontSize: 16)),
                  Switch(
                    value: repeats != null,
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          repeats =
                              ""; // Show the recurrence selector if switched on
                        } else {
                          repeats = null; // Clear the repeats if switched off
                        }
                      });
                    },
                  ),
                ],
              ),
              // Recurrence Selector
              if (repeats != null)
                RecurrenceSelector(
                  initialRecurrenceRule: repeats!,
                  onRecurrenceSelected: (String rrule) {
                    setState(() {
                      repeats = rrule; // Set the selected rrule
                    });
                  },
                ),
              Text(repeats ?? ""),
              const SizedBox(height: 40),
              // Submit and Cancel Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (date != null && time != null) {
                        Exercise newExercise = Exercise(
                          purpose: purpose,
                          data: data,
                          date: date!,
                          time: DateTime(
                            date!.year,
                            date!.month,
                            date!.day,
                            time!.hour,
                            time!.minute,
                          ),
                          duration: duration ?? Duration.zero,
                          repeats: repeats ?? "",
                        )..id = widget.exercise?.id ?? 0;
                        widget.onSubmit(newExercise);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Submit',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
