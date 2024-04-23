import 'package:flutter/material.dart';

class ConnectedWidgetsRowMolecule extends StatelessWidget {
  final List<Widget> widgets;
  const ConnectedWidgetsRowMolecule({
    super.key,
    required this.widgets,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widgets[0],
        Expanded(
          child: Container(
            width: 2,
            height: 2,
            color: const Color.fromARGB(255, 112, 112, 112),
          ),
        ),
        widgets[1],
      ],
    );
  }
}
