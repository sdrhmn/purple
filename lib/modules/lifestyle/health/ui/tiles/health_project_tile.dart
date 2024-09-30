import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/lifestyle/health/health_models.dart';
import 'package:timely/modules/lifestyle/health/ui/health_tasks_page.dart'; // Import the tasks page

class HealthProjectTile extends StatelessWidget {
  final HealthProject project;

  const HealthProjectTile({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final latestTask =
        project.healthTasks.isNotEmpty ? project.healthTasks.last : null;
    final formattedDate = latestTask != null
        ? DateFormat.MMMd()
            .format(latestTask.dateTime) // Show only date as "Sep 27"
        : 'N/A';
    final formattedTime = latestTask != null
        ? DateFormat.jm().format(latestTask.dateTime)
        : 'N/A';

    // Determine the background color based on criticality
    Color getBackgroundColor(int criticality) {
      if (criticality == 5) return Colors.red;
      if (criticality == 3 || criticality == 4) return Colors.yellow[800]!;
      return Colors.green;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HealthProjectTasksPage(
              project,
              onEdit: () {},
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            color: getBackgroundColor(project.criticality),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Circles for Date and Time
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circle for Date with padding
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        formattedDate,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12, // Increased font size for date
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Circle for Time with padding
                  Container(
                    padding:
                        const EdgeInsets.all(4.0), // Added padding around time
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          formattedTime,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Increased font size for time
                            fontWeight: FontWeight.bold, // Bold text
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16.0),
              // Right side with text, centered and larger font size
              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center content vertically
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Condition with updated font size
                    Text(
                      project.condition,
                      style: const TextStyle(
                        fontSize: 18, // Increased font size for condition
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    // Latest Task with updated font size
                    Text(
                      latestTask?.task ?? "N/A",
                      style: const TextStyle(
                        fontSize: 16, // Increased font size for task
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    // Latest Update with updated font size
                    Text(
                      latestTask?.update ?? "N/A",
                      style: const TextStyle(
                        fontSize: 14, // Increased font size for update
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
