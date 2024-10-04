import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting
import 'package:timely/modules/lifestyle/diary/diary_model.dart';

class DiaryTile extends StatelessWidget {
  final DiaryModel diary;
  final Function(DiaryModel) onDelete;
  final Function(DiaryModel) onTap;

  const DiaryTile({
    Key? key,
    required this.diary,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the date
    String formattedDate = DateFormat('dd-MMM-yyyy')
        .format(diary.date); // Assuming diary.date is a DateTime object
    String location = diary.place; // Assuming diary.place is a string
    String dateAndPlace = '$formattedDate, $location';

    return InkWell(
      onTap: () {
        onTap(diary);
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        color: Colors.grey[900], // Assuming dark color theme
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Align children to opposite ends
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side for diary details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First row: Date + Place
                    Text(
                      dateAndPlace,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors
                            .white54, // Light color for better readability
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Second row: Title
                    Text(
                      diary.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .white, // White for contrast against dark theme
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Third row: Description
                    Text(
                      diary.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70, // Slightly dimmed white
                      ),
                    ),
                  ],
                ),
              ),

              // Right side for pop-up menu
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white, // Color of the three dots
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    // Call the delete function when the delete option is selected
                    onDelete(diary);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child:
                          Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
