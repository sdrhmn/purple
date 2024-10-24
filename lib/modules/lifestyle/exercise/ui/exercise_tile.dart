import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/lifestyle/exercise/data/exercise_model.dart';
import 'package:rrule/rrule.dart';

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExerciseTile({
    Key? key,
    required this.exercise,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circle for Date and Time
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDateTimeCircle(),
                ],
              ),
              const SizedBox(width: 20.0),
              // Main content area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Menu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            exercise.purpose == ExercisePurpose.evaluation
                                ? "Evaluation"
                                : "Workout",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              onEdit();
                            } else if (value == 'delete') {
                              onDelete();
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    // Exercise Details
                    ..._buildExerciseDetails(),
                    const SizedBox(height: 10),
                    // Add this new widget to display the recurring rule
                    _buildRecurringRuleText(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create the date and time circle with a divider
  Widget _buildDateTimeCircle() {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('EEE, d MMM').format(exercise.date),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(
            height: 10,
            thickness: 1,
            color: Colors.grey,
          ),
          Text(
            DateFormat.jm().format(exercise.time),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build exercise details
  List<Widget> _buildExerciseDetails() {
    List<Widget> details = [];
    for (int i = 0; i < exercise.data.length; i++) {
      details.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${i + 1}. ${exercise.data[i][0]}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (exercise.purpose == ExercisePurpose.workout)
                Text(
                  '${exercise.data[i][1]}r x ${exercise.data[i][2]}s',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              if (exercise.purpose == ExercisePurpose.evaluation)
                Text(
                  '${exercise.data[i][1]}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
            ],
          ),
        ),
      );
    }
    return details;
  }

  // New method to build the recurring rule text
  Widget _buildRecurringRuleText() {
    if (exercise.repeats.isEmpty) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<String>(
      future: _getHumanReadableRecurringRule(exercise.repeats),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Text(
            'Repeats: ${snapshot.data}',
            style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Future<String> _getHumanReadableRecurringRule(String rruleString) async {
    final rrule = RecurrenceRule.fromString(rruleString);
    final l10n = await RruleL10nEn.create();
    return rrule.toText(l10n: l10n);
  }
}
