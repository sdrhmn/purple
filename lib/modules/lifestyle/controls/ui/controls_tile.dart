import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/lifestyle/controls/controls_model.dart';

class ControlsTile extends StatelessWidget {
  final ControlsModel controls;
  final void Function(ControlsModel) onEdit;
  final void Function(ControlsModel) onDelete;

  const ControlsTile({
    super.key,
    required this.controls,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green[800],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          // Date and Comments
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat(DateFormat.ABBR_MONTH_DAY)
                    .format(controls.date), // Display the date
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                controls.comments,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),

          const SizedBox(width: 20),

          // Images and Values
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Communication image
                _ImageAndValue(
                    imagePath: "assets/Controls/communication.png",
                    value: controls.values[0].toString()),
                // Food image
                _ImageAndValue(
                    imagePath: "assets/Controls/food.png",
                    value: controls.values[1].toString()),
                // Spending image
                _ImageAndValue(
                    imagePath: "assets/Controls/spending.png",
                    value: controls.values[2].toString()),
              ],
            ),
          ),

          // Options (Edit/Delete)
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'edit') {
                onEdit(controls); // Pass ControlsModel to onEdit
              } else if (result == 'delete') {
                onDelete(controls); // Pass ControlsModel to onDelete
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ImageAndValue extends StatelessWidget {
  final String imagePath;
  final String value;

  const _ImageAndValue({
    required this.imagePath,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24.0, // Adjust size as needed
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: 30.0, // Adjust image size as needed
            height: 30.0,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
