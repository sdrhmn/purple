import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';

class RecurrenceSelector extends StatefulWidget {
  final Function(String) onRecurrenceSelected;
  final String? initialRecurrenceRule;

  const RecurrenceSelector({
    Key? key,
    required this.onRecurrenceSelected,
    this.initialRecurrenceRule,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RecurrenceSelectorState createState() => _RecurrenceSelectorState();
}

class _RecurrenceSelectorState extends State<RecurrenceSelector> {
  Frequency _frequency = Frequency.daily;
  int _interval = 1;
  final List<int> _selectedWeekdays = [];
  final List<int> _selectedMonthDays = [];
  String _weekdayPosition = "First";
  String _selectedDayOfWeek = "Monday";
  bool _eachSelected = true;

  // New variables for yearly recurrence
  final List<int> _selectedMonths = [];
  bool _showYearlyAdvancedOption = false;

  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<String> _weekdayPositions = [
    'First',
    'Second',
    'Third',
    'Fourth',
    'Fifth',
    'Last'
  ];

  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialRecurrenceRule != null &&
        widget.initialRecurrenceRule!.isNotEmpty) {
      final rrule = RecurrenceRule.fromString(widget.initialRecurrenceRule!);
      _initializeFromRecurrenceRule(rrule);
    }
  }

  void _initializeFromRecurrenceRule(RecurrenceRule rrule) {
    _frequency = rrule.frequency;
    _interval = rrule.interval ?? 1;
    if (_frequency == Frequency.weekly) {
      _selectedWeekdays.clear();
      _selectedWeekdays.addAll(rrule.byWeekDays.map((day) => day.day));
    } else if (_frequency == Frequency.monthly) {
      _eachSelected = rrule.byMonthDays.isNotEmpty;
      if (_eachSelected) {
        _selectedMonthDays.clear();
        _selectedMonthDays.addAll(rrule.byMonthDays);
      } else {
        _weekdayPosition = _weekdayPositions[rrule.bySetPositions.first - 1];
      }
      _selectedDayOfWeek = _daysOfWeek[rrule.byWeekDays.first.day];
    }
    // Add initialization for yearly frequency
    else if (_frequency == Frequency.yearly) {
      _selectedMonths.clear();
      _selectedMonths.addAll(rrule.byMonths);
      _showYearlyAdvancedOption = rrule.byWeekDays.isNotEmpty;
      if (_showYearlyAdvancedOption) {
        _weekdayPosition = _weekdayPositions[rrule.bySetPositions.first - 1];
        _selectedDayOfWeek = _daysOfWeek[rrule.byWeekDays.first.day - 1];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Frequency Selector
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<Frequency>(
                underline: Container(),
                borderRadius: BorderRadius.circular(12),
                value: _frequency,
                onChanged: (Frequency? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _frequency = newValue;
                      _interval = 1;
                      _selectedWeekdays.clear();
                      _selectedMonthDays.clear();
                      _selectedMonths.clear();
                      _showYearlyAdvancedOption = false;
                    });
                  }
                },
                items: [
                  Frequency.daily,
                  Frequency.weekly,
                  Frequency.monthly,
                  Frequency.yearly
                ].map((Frequency frequency) {
                  return DropdownMenuItem<Frequency>(
                    value: frequency,
                    child: Text(
                      frequency.toString().split('.').last[0].toUpperCase() +
                          frequency
                              .toString()
                              .split('.')
                              .last
                              .substring(1)
                              .toLowerCase(),
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Interval input field
          Text(
            "Repeat every",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: _interval - 1),
              itemExtent: 40.0,
              onSelectedItemChanged: (index) {
                _interval = index + 1;
              },
              children: List.generate(
                _frequency == Frequency.yearly ? 10 : 31,
                (index) => Center(
                  child: Text(
                    "${index + 1} ${_frequency == Frequency.daily ? 'day${index == 0 ? '' : 's'}' : _frequency == Frequency.weekly ? 'week${index == 0 ? '' : 's'}' : _frequency == Frequency.monthly ? 'month${index == 0 ? '' : 's'}' : 'year${index == 0 ? '' : 's'}'}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Daily options
          if (_frequency == Frequency.daily) ...[
            // Daily options don't require additional UI elements
          ],
          // Weekly options
          if (_frequency == Frequency.weekly) ...[
            const Text(
              "Select Days:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _daysOfWeek.asMap().entries.map((entry) {
                final dayIndex = entry.key + 1;
                final dayName = entry.value;
                return ChoiceChip(
                  label: Text(dayName.substring(0, 3)),
                  selected: _selectedWeekdays.contains(dayIndex),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedWeekdays.add(dayIndex);
                      } else {
                        _selectedWeekdays.remove(dayIndex);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
          // Monthly options
          if (_frequency == Frequency.monthly) ...[
            const Text(
              "Select Option:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Each:", style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Switch(
                  value: _eachSelected,
                  onChanged: (value) {
                    setState(() {
                      _eachSelected = value;
                    });
                  },
                ),
                const SizedBox(width: 16),
                const Text("On:", style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            if (_eachSelected)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: List.generate(31, (index) {
                  return ChoiceChip(
                    label: Text("${index + 1}"),
                    selected: _selectedMonthDays.contains(index + 1),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedMonthDays.add(index + 1);
                        } else {
                          _selectedMonthDays.remove(index + 1);
                        }
                      });
                    },
                  );
                }),
              )
            else
              SizedBox(
                height: 150,
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem:
                                _weekdayPositions.indexOf(_weekdayPosition)),
                        itemExtent: 40.0,
                        onSelectedItemChanged: (index) {
                          _weekdayPosition = _weekdayPositions[index];
                        },
                        children: _weekdayPositions
                            .map((pos) => Center(
                                  child: Text(pos,
                                      style: const TextStyle(fontSize: 18)),
                                ))
                            .toList(),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: _daysOfWeek.indexOf(_selectedDayOfWeek),
                        ),
                        itemExtent: 40.0,
                        onSelectedItemChanged: (index) {
                          _selectedDayOfWeek = _daysOfWeek[index];
                        },
                        children: _daysOfWeek
                            .map((day) => Center(
                                  child: Text(day,
                                      style: const TextStyle(fontSize: 18)),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          // Yearly options
          if (_frequency == Frequency.yearly) ...[
            const Text(
              "Select Months:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _monthNames.asMap().entries.map((entry) {
                final monthIndex = entry.key + 1;
                final monthName = entry.value;
                return ChoiceChip(
                  label: Text(monthName.substring(0, 3)),
                  selected: _selectedMonths.contains(monthIndex),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedMonths.add(monthIndex);
                      } else {
                        _selectedMonths.remove(monthIndex);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Advanced:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Switch(
                  value: _showYearlyAdvancedOption,
                  onChanged: (value) {
                    setState(() {
                      _showYearlyAdvancedOption = value;
                    });
                  },
                ),
              ],
            ),
            if (_showYearlyAdvancedOption) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 150,
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem:
                                _weekdayPositions.indexOf(_weekdayPosition)),
                        itemExtent: 40.0,
                        onSelectedItemChanged: (index) {
                          _weekdayPosition = _weekdayPositions[index];
                        },
                        children: _weekdayPositions
                            .map((pos) => Center(
                                  child: Text(pos,
                                      style: const TextStyle(fontSize: 18)),
                                ))
                            .toList(),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: _daysOfWeek.indexOf(_selectedDayOfWeek),
                        ),
                        itemExtent: 40.0,
                        onSelectedItemChanged: (index) {
                          _selectedDayOfWeek = _daysOfWeek[index];
                        },
                        children: _daysOfWeek
                            .map((day) => Center(
                                  child: Text(day,
                                      style: const TextStyle(fontSize: 18)),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: _buildAndSaveRecurrenceRule,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(
                  "Save Recurrence Rule",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to generate the RRULE string and pass it to the parent widget
  void _buildAndSaveRecurrenceRule() {
    RecurrenceRule rrule;
    if (_frequency == Frequency.daily) {
      rrule = RecurrenceRule(frequency: Frequency.daily, interval: _interval);
    } else if (_frequency == Frequency.weekly) {
      rrule = RecurrenceRule(
        frequency: Frequency.weekly,
        interval: _interval,
        byWeekDays: _selectedWeekdays
            .map((dayIndex) => ByWeekDayEntry(dayIndex))
            .toSet()
            .toList(),
      );
    } else if (_frequency == Frequency.monthly) {
      rrule = RecurrenceRule(
        frequency: Frequency.monthly,
        interval: _interval,
        byMonthDays: _eachSelected ? _selectedMonthDays : [],
        bySetPositions: !_eachSelected
            ? [_weekdayPositions.indexOf(_weekdayPosition) + 1]
            : [],
        byWeekDays: !_eachSelected
            ? {ByWeekDayEntry(_daysOfWeek.indexOf(_selectedDayOfWeek) % 7 + 1)}
                .toList()
            : [],
      );
    } else {
      rrule = RecurrenceRule(
        frequency: Frequency.yearly,
        interval: _interval,
        byMonths: _selectedMonths,
        bySetPositions: _showYearlyAdvancedOption
            ? [_weekdayPositions.indexOf(_weekdayPosition) + 1]
            : [],
        byWeekDays: _showYearlyAdvancedOption
            ? {ByWeekDayEntry(_daysOfWeek.indexOf(_selectedDayOfWeek) % 7 + 1)}
                .toList()
            : [],
      );
    }

    widget.onRecurrenceSelected(rrule.toString());
    print(DateTime.now().copyWith(isUtc: true));
    print(rrule
        .getInstances(
          start: DateTime.now().copyWith(isUtc: true),
        )
        .take(1));
  }
}

// Add this extension method at the end of the file
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
