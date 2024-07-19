import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/reusables.dart';

import 'package:timely/values.dart';

class TabSelectionScreen extends StatelessWidget {
  final bool? navigateToInputScreen;
  const TabSelectionScreen({super.key, this.navigateToInputScreen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Tab").fontSize(18),
      ),
      body: GridView(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        children: [
          ...<Widget>[
            for (var i in List.generate(navigateToInputScreen == true ? 4 : 5,
                (index) => navigateToInputScreen == true ? index + 1 : index))
              tabIcons[i]
                  .padding(all: 10)
                  .decorated(color: Colors.purpleAccent, shape: BoxShape.circle)
                  .padding(all: 10)
                  .decorated(color: Colors.purple[900], shape: BoxShape.circle)
                  .padding(all: 10)
                  .card(
                      color: Colors.purple[800],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))
                  .constrained(height: 100, width: 100)
                  .gestures(onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text(appBarHeadings[i] ?? "PurpleTime"),
                        leading: tabIcons[i].padding(all: 10),
                      ),
                      body: navigateToInputScreen == true
                          ? tabInputScreens[i]
                          : tabs[i],
                    ),
                  ),
                );
              }).padding(all: 10)
          ]
        ],
      ),
    );
  }
}
