import 'package:timely/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateButtonAtom extends StatelessWidget {
  final DateTime? initialDate;
  final Function(DateTime date) onDateChanged;
  final Size buttonSize;
  final String? defaultText;

  const DateButtonAtom({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
    this.buttonSize = const Size(70, 20),
    this.defaultText,
  });
  const DateButtonAtom.large({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
    this.buttonSize = const Size(170, 50),
    this.defaultText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonSize.width,
      height: buttonSize.height,
      child: ElevatedButton(
        onPressed: () async {
          var dateSelected = await showDatePicker(
            context: context,
            initialDate: initialDate ?? DateTime.now(),
            firstDate: DateTime(0),
            lastDate: DateTime(DateTime.now().year + 50),
          );
          if (dateSelected != null) {
            onDateChanged(dateSelected);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple[600],
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                AppSizes.r_8,
              ),
            ),
          ),
        ),
        child: Text(
          initialDate != null
              ? DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(initialDate!)
              : defaultText ?? "",
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}

class DropdownButtonAtom extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final int selectedIndex;
  final void Function(dynamic value) onChanged;
  const DropdownButtonAtom({
    super.key,
    required this.items,
    required this.onChanged,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedIndex,
      items: items,
      onChanged: onChanged,
    );
  }
}

class TextButtonAtom extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;

  const TextButtonAtom({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r_8),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}

class TimeButtonAtom extends StatelessWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay time) onTimeChanged;
  final Size buttonSize;

  const TimeButtonAtom({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
    this.buttonSize = const Size(120, 30),
  });
  const TimeButtonAtom.large({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
    this.buttonSize = const Size(170, 50),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonSize.width,
      height: buttonSize.height,
      child: ElevatedButton(
        onPressed: () async {
          TimeOfDay? timeSelected =
              await showTimePicker(context: context, initialTime: initialTime);
          if (timeSelected != null) {
            onTimeChanged(timeSelected);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple[700],
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                AppSizes.r_8,
              ),
            ),
          ),
        ),
        child: Text(
          initialTime.format(context),
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}
