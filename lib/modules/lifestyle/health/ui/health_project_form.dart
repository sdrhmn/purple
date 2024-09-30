import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Make sure to import this for Cupertino widgets
import 'package:timely/modules/lifestyle/health/health_models.dart';

class HealthProjectEditForm extends StatefulWidget {
  final HealthProject project;
  final Function(HealthProject) onSubmit;

  const HealthProjectEditForm(
      {super.key, required this.project, required this.onSubmit});

  @override
  // ignore: library_private_types_in_public_api
  _HealthProjectEditFormState createState() => _HealthProjectEditFormState();
}

class _HealthProjectEditFormState extends State<HealthProjectEditForm> {
  late TextEditingController _conditionController;
  late int _criticality;

  @override
  void initState() {
    super.initState();
    _conditionController =
        TextEditingController(text: widget.project.condition);
    _criticality = widget
        .project.criticality; // Assume criticality is an int between 1 and 5
  }

  @override
  void dispose() {
    _conditionController.dispose();
    super.dispose();
  }

  void _submit() {
    final updatedProject = widget.project
      ..condition = _conditionController.text
      ..criticality = _criticality;

    widget.onSubmit(updatedProject);

    Navigator.of(context).pop();
  }

  void _showCriticalityPicker() {
    // Use a local variable to hold the selected criticality
    int selectedCriticality = _criticality;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250, // Height for the picker
        color: Colors.white,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Container(
                  height: 200,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedCriticality -
                          1, // Adjust for zero-based index
                    ),
                    itemExtent: 50.0,
                    onSelectedItemChanged: (int index) {
                      // Update the local variable instead of the project's criticality directly
                      selectedCriticality = index + 1;
                    },
                    children: List<Widget>.generate(5, (index) {
                      return Center(
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () {
                  // Set the project's criticality when the Done button is pressed
                  setState(() {
                    _criticality = selectedCriticality;
                    widget.project.criticality = _criticality;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Updated method to accept the controller
  Widget _buildTextField({
    required String label,
    required TextEditingController
        controller, // Using controller passed as argument
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return TextField(
      onTapOutside: (e) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      textCapitalization: TextCapitalization.sentences,
      controller: controller, // Using the passed controller
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[900],
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Project')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              label: 'Condition',
              controller: _conditionController,
              onChanged: (value) {
                setState(() {
                  widget.project.condition = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text("Criticality"),
                Spacer(),
                SizedBox(width: 80, child: _buildCriticalityBar()),
              ],
            ), // Added criticality bar here
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriticalityBar() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          double newCriticality =
              ((details.localPosition.dx / 80) * 5).clamp(1, 5);
          _criticality = newCriticality.round();
          widget.project.criticality = _criticality;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return _buildBar(index + 1);
          }),
        ),
      ),
    );
  }

  Widget _buildBar(int index) {
    double height = 10.0 * index; // Increase height for each bar

    // Set color based on criticality level
    Color getColor(int index) {
      if (_criticality >= index) {
        if (index <= 2) return Colors.green;
        if (index <= 4) return Colors.yellow[700]!;
        return Colors.red;
      }
      return Colors.grey;
    }

    return Container(
      width: 10, // Set bar width
      height: height,
      decoration: BoxDecoration(
        color: getColor(index),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
