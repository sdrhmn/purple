import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/lifestyle/kpi/kpi_model.dart';

class KPITile extends StatelessWidget {
  final KPIModel kpi;
  final void Function(KPIModel) onEdit;
  final void Function(KPIModel) onDelete;

  const KPITile({
    super.key,
    required this.kpi,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[800],
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
                    .format(kpi.date), // Display the date
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                kpi.comments,
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
                // Activity image
                _ImageAndValue(
                    imagePath: "assets/KPI/activity.png",
                    value: kpi.values[0].toString()),
                // Sleep image
                _ImageAndValue(
                    imagePath: "assets/KPI/sleep.png",
                    value: kpi.values[1].toString()),
                // Bowel movement image
                _ImageAndValue(
                    imagePath: "assets/KPI/bowel.png",
                    value: kpi.values[2].toString()),
                // Weight image
                _ImageAndValue(
                    imagePath: "assets/KPI/weight.png",
                    value: kpi.values[3].toString()),
              ],
            ),
          ),

          // Options (Edit/Delete)
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'edit') {
                onEdit(kpi); // Pass KPIModel to onEdit
              } else if (result == 'delete') {
                onDelete(kpi); // Pass KPIModel to onDelete
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
