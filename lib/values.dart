import 'package:flutter/material.dart';

Map<int, String> appBarHeadings = {
  12: "PurpleTime",
  0: "Controls",
  1: "Repeat Activities",
  2: "Ad hoc Activities",
  3: "Health",
  4: "Exercises",
};

class Tab1Headings {
  static String items = "Items";
  static String time = "Time";
  static String status = "Status";
  static String start = "Start";
  static String pause = "Pause";
  static String stop = "Stop";
  static String mScore = "M-Score";
  static String fScore = "F-Score";
  static String sScore = "S-Score";
}

class Tab2Headings {
  static String todaysTasks = "Today's Tasks";
  static String upcomingTasks = "Upcoming Tasks";

  // Input Screen
  static String activity = "Activity";
  static String time = "Time";
  static String duration = "Duration";
  static String repeats = "Repeats";
}

class Tab3Headings {
  static String scheduled = "Scheduled";
  static String nonScheduled = "Non-Scheduled";

  // Input Screen
  static String activity = "Activity";
  static String scheduledSwitch = "Scheduled";
  static String date = "Date";
  static String time = "Time";
  static String priority = "Priority";
}

class Tab4Headings {
  static String date = "Date";
  static String s = "S";
  static String p = "P";
  static String w = "W";
  static String weight = "Weight";

  // Input Screen
  static String sScore = "Activity Level";
  static String pScore = "Sleep";
  static String wScore = "Bowel Movement";
  static List<String> sliderHeadings = ["Good", "Fair", "Poor"];
  static String weightTextHint = "65.0";
}

class LaunchScreenHeadings {
  static String internal = "Internal";
  static String external = "External";

  static List<String> labels = ["Start", "Pause", "Stop"];
}

// Icons
final tab1Icon = Image.asset("assets/icons/tab_1_icon.png");
final tab2Icon = Image.asset("assets/icons/tab_2_icon.png");
final tab3Icon = Image.asset("assets/icons/tab_3_icon.png");
final tab4Icon = Image.asset("assets/icons/tab_4_icon.png");
final tab5Icon = Image.asset("assets/icons/tab_5_icon.png");
const tab6Icon = Icon(Icons.history);
const tab7Icon = Icon(Icons.construction_rounded);
const tab8Icon = Icon(Icons.construction_rounded);
const tab9Icon = Icon(Icons.construction_rounded);
const tab10Icon = Icon(Icons.construction_rounded);
const tab11Icon = Icon(Icons.construction_rounded);
final foodIcon = Image.asset("assets/icons/food.png");
final communicationIcon = Image.asset("assets/icons/communication.png");
final timeIcon = Image.asset("assets/icons/time.png");
final weightIcon = Image.asset("assets/icons/weight.png");
final sleepIcon = Image.asset("assets/icons/sleep.png");
final bowelIcon = Image.asset("assets/icons/bowel.png");
