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
        ? DateFormat.yMMMd().add_jm().format(latestTask.dateTime)
        : 'No tasks available';

    return InkWell(
      // Wrap with InkWell for tap detection
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        // Navigate to the tasks screen
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
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue[800]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                project.criticality.toString(),
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.condition,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Next Task: ${latestTask?.task ?? "N/A"}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Update: ${latestTask?.update ?? "N/A"}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Date: $formattedDate',
                      style: const TextStyle(
                        fontSize: 14,
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
