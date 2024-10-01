import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/lifestyle/health/health_models.dart';
import 'package:timely/modules/lifestyle/health/ui/health_tasks_page.dart';

class HealthProjectTile extends StatelessWidget {
  final HealthProject project;
  final Function() onDelete; // Callback for deleting the project
  final Function() onMarkComplete; // Callback for marking the project complete
  final Function() onEdit; // Callback for editing the project

  const HealthProjectTile({
    Key? key,
    required this.project,
    required this.onDelete, // Accept the delete callback
    required this.onMarkComplete, // Accept the mark complete callback
    required this.onEdit, // Accept the edit callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final latestTask =
        project.healthTasks.isNotEmpty ? project.healthTasks.last : null;
    final formattedDate = latestTask != null
        ? DateFormat.MMMd().format(latestTask.dateTime)
        : 'N/A';
    final formattedTime = latestTask != null
        ? DateFormat.jm().format(latestTask.dateTime)
        : 'N/A';

    // Determine the background color based on criticality

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
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Circles for Date and Time
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStaticCriticalityBar(project.criticality),
                      SizedBox(height: 10),
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                formattedDate,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(height: 2),
                              Text(
                                formattedTime,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  // Right side with text, centered and larger font size
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          latestTask?.task ?? "N/A",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          latestTask?.update ?? "N/A",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Three dots menu
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'complete',
                            child: Text('Mark Complete'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') {
                            onEdit(); // Trigger the edit callback
                          } else if (value == 'complete') {
                            onMarkComplete();
                          } else if (value == 'delete') {
                            onDelete();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to display non-selectable criticality bar
  Widget _buildStaticCriticalityBar(int criticality) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          double height = 50;
          Color getColor(int index) {
            if (criticality >= index + 1) {
              if (index + 1 <= 2) return Colors.green;
              if (index + 1 <= 4) return Colors.yellow[700]!;
              return Colors.red;
            }
            return Colors.grey;
          }

          return Container(
            width: 15,
            height: height,
            decoration: BoxDecoration(
              color: getColor(index),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}
