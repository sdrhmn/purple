import 'package:flutter/material.dart';

class ReminderView extends StatefulWidget {
  const ReminderView({super.key});

  @override
  ReminderViewState createState() => ReminderViewState();
}

class ReminderViewState extends State<ReminderView> {
  int _selectedRadioValue = 30; // 30 is for Every 30 min

  final List<int> reminderMinutes = [15, 30, 45, 60, 90, 120];

  void _handleRadioValueChanged(int? value) =>
      setState(() => _selectedRadioValue = value!);

  void _handleSaveButtonPressed() async {
    // Handle saving reminder settings based on _selectedRadioValue
    // You can call the scheduleNotification function here (from previous response)
    Navigator.pop(context); // Close the reminder view after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Text(
              'To Open the App',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: reminderMinutes.length,
              itemBuilder: (context, index) {
                return RadioListTile<int>(
                  value: reminderMinutes[index],
                  groupValue: _selectedRadioValue,
                  onChanged: _handleRadioValueChanged,
                  title: Text(
                    'Every ${reminderMinutes[index]} minutes',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: _handleSaveButtonPressed,
                child: const Icon(Icons.done_all),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
