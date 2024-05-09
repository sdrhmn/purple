import 'package:flutter/material.dart';

final appDarkTheme = ThemeData(
  useMaterial3: true,

  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    // ···
    brightness: Brightness.dark,
  ),

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 25,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      fontSize: 17,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
    ),
    labelSmall: TextStyle(
      fontSize: 8,
    ),
    labelMedium: TextStyle(
      fontSize: 15,
      fontStyle: FontStyle.italic,
    ),
  ),
);

class Tab1Colors {
  static List<Color> alternateTileColors = [Colors.purple, Colors.purple[900]!];
}

class LaunchScreenColors {
  static Color bgTimer = Colors.pink[400]!;
  static Color bgAlert = Colors.pink[400]!;
  static Color bgInternal = Colors.purple[700]!;
  static Color bgFMS = Colors.purple[900]!;
  static const List<Color> bgFMSRadioButtons = [
    Colors.green,
    Colors.yellow,
    Colors.red
  ];
  static const Color bgExternalHeader = Colors.purple;
  static const Color bgSeparator = Colors.black;
  static const Color bgTaskTodayTile = Colors.purple;
  static const Color bgNonScheduledTile = Colors.purple;
}

class SchedulingColors {
  static const Color? bgTodaysTasksHeader = null;
  static const Color? bgUpcomingTasksHeader = null;

  static Color bgTodaysTaskTile = Colors.purple[800]!;
  static Color bgUpcomingTaskTile = Colors.purple[800]!;
}

class Tab3Colors {
  static const Color? bgScheduledHeader = null;
  static const Color? bgNonScheduledHeader = null;
  static const Color? bgDateHeader = null;

  static const List<Color> bgPriorities = [
    Colors.purple,
    Colors.green,
    Colors.pink,
  ];

  static const Color bgDatePassed = Colors.orange;
}

class SPWPageColors {
  static const Color? bgSPWHeaderRow = null;

  static const Color bgDateCell = Colors.black;
  static const List<Color> bgSPWCells = [
    Colors.green,
    Colors.yellow,
    Colors.red
  ]; // Color is based on the score. 0 for green, 1 for yellow and 2 for red.
  static const Color bgWeightCell = Colors.black;

  static List<Color> pickerColumnColors = [
    Colors.purple[800]!,
    Colors.purple[700]!,
    Colors.purple[800]!,
  ];
}

class Tab8Colors {}

class Tab9Colors {}

class Tab10Colors {}

class Tab11Colors {
  static final List<Color> optionColors = [
    Colors.green[700]!,
    Colors.red[700]!,
  ];
}

class Tab12Colors {}

class AppSizes {
  AppSizes._();

  static const double w_0 = 0.0;
  static const double h_4 = 4.0;
  static const double h_8 = 8.0;
  static const double h_12 = 12.0;
  static const double h_16 = 16.0;
  static const double h_20 = 20.0;
  static const double h_24 = 24.0;
  static const double h_28 = 28.0;
  static const double h_32 = 32.0;
  static const double h_36 = 36.0;
  static const double h_40 = 40.0;
  static const double h_44 = 44.0;
  static const double h_48 = 48.0;
  static const double h_52 = 42.0;
  static const double h_56 = 56.0;
  static const double h_60 = 60.0;
  static const double h_64 = 64.0;

  // Radiu
  static const double r_8 = 8.0;
  static const double r_16 = 16.0;
  static const double r_24 = 24.0;

  // Padding
  static const double p_8 = 8;
  static const double p_12 = 12;
  static const double p_16 = 16;
  static const double p_24 = 24;

  static Size mediaQuery(BuildContext context) => MediaQuery.of(context).size;
}

class AppTypography {
  AppTypography._();

  // Font Sizes
  static const double sizeXXS = 8;
  static const double sizeXS = 13;
  static const double sizeSM = 21;
  static const double sizeSL = 28;
  static const double sizeMD = 34;
  static const double sizeLG = 40;
  static const double sizeXL = 48;
  static const double sizeXXL = 55;

  // Styles
  static const TextStyle regularStyle = TextStyle();
  static const TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);
  static const TextStyle italicStyle = TextStyle(fontStyle: FontStyle.italic);
}

// Typograpy.general
TextStyle timelyStyle = const TextStyle(fontSize: 20);

TextStyle h3TextStyle = const TextStyle(
  fontSize: 15,
);

// Tab Icons
Icon launchScreenIcon = const Icon(Icons.home);
Icon tabOneIcon = const Icon(Icons.looks_one_outlined);
Icon tabTwoIcon = const Icon(Icons.looks_two_outlined);
Icon tabThreeIcon = const Icon(Icons.looks_3_outlined);
Icon tabFourIcon = const Icon(Icons.looks_4_outlined);
Icon tabFiveIcon = const Icon(Icons.looks_5_outlined);
Icon tabSixIcon = const Icon(Icons.looks_6_outlined);
Icon tabSevenIcon = const Icon(Icons.pentagon);
Icon tabEightIcon = const Icon(Icons.pentagon);
Icon tabNineIcon = const Icon(Icons.pentagon);
Icon tabTenIcon = const Icon(Icons.pentagon);
Icon tabElevenIcon = const Icon(Icons.pentagon);
Icon tabTwelveIcon = const Icon(Icons.pentagon);

// Tab Colors
Color bgTabButtonColor = Colors.purple;

// LaunchScreen Section Colors
Color launchSectionOneTimerColor = Colors.green;
Color launchSectionOneAlertColor = Colors.green;
Color launchSectionTwoColor = Colors.orange;
Color launchSectionThreeColor = Colors.blueGrey;
Color launchSectionFourColor = Colors.pinkAccent;

// LaunchScreen Text Colors
Color launchSectionOneTimerTextColor = Colors.white;
Color launchSectionOneAlertTextColor = Colors.white;
Color launchSectionTwoTextColor = Colors.black;
Color launchSectionThreeTextColor = Colors.white;
