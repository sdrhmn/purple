import 'package:styled_widget/styled_widget.dart';
import 'package:timely/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateButtonAtom extends StatelessWidget {
  final DateTime? currentDate;
  final Function(DateTime date) onDateChanged;
  final Size buttonSize;
  final String? defaultText;
  final Icon? icon;

  const DateButtonAtom({
    super.key,
    required this.currentDate,
    required this.onDateChanged,
    this.buttonSize = const Size(70, 20),
    this.defaultText,
    this.icon,
  });
  const DateButtonAtom.large({
    super.key,
    required this.currentDate,
    required this.onDateChanged,
    this.buttonSize = const Size(170, 50),
    this.defaultText,
    this.icon,
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
            initialDate: currentDate ?? DateTime.now(),
            firstDate: DateTime(0),
            lastDate: DateTime(DateTime.now().year + 50),
          );
          if (dateSelected != null) {
            onDateChanged(dateSelected);
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                AppSizes.r_8,
              ),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              currentDate != null
                  ? DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY)
                      .format(currentDate!)
                  : defaultText ?? "Select Date",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (icon != null) icon!.padding(),
          ],
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
  final Size buttonSize;
  final Icon? icon;

  const TextButtonAtom({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.buttonSize = const Size(120, 30),
    this.icon,
  });

  const TextButtonAtom.large({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.buttonSize = const Size(170, 50),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonSize.width,
      height: buttonSize.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r_8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (icon != null) icon!,
          ],
        ),
      ),
    );
  }
}

class TimeButtonAtom extends StatelessWidget {
  final TimeOfDay? initialTime;
  final Function(TimeOfDay time) onTimeChanged;
  final Size buttonSize;
  final Icon? icon;

  const TimeButtonAtom({
    super.key,
    this.initialTime,
    required this.onTimeChanged,
    this.buttonSize = const Size(120, 30),
    this.icon,
  });
  const TimeButtonAtom.large({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
    this.buttonSize = const Size(170, 50),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonSize.width,
      height: buttonSize.height,
      child: ElevatedButton(
        onPressed: () async {
          TimeOfDay? timeSelected = await showTimePicker(
              context: context, initialTime: initialTime ?? TimeOfDay.now());
          if (timeSelected != null) {
            onTimeChanged(timeSelected);
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                AppSizes.r_8,
              ),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              initialTime != null
                  ? initialTime!.format(context)
                  : "Select Time",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (icon != null) icon!,
          ],
        ),
      ),
    );
  }
}
