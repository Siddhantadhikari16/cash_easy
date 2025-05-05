import 'package:flutter/widgets.dart';

class ScreenUtil {
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleWidth;
  static late double scaleHeight;
  static late double textScaleFactor;

  static void init(BuildContext context, {double designWidth = 375, double designHeight = 812}) {
    final Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;

    scaleWidth = screenWidth / designWidth;
    scaleHeight = screenHeight / designHeight;

    textScaleFactor = scaleWidth; // Adjust text based on width
  }

  static double scaleW(double width) => width * scaleWidth;
  static double scaleH(double height) => height * scaleHeight;
  static double scaleFont(double fontSize) => fontSize * textScaleFactor;
}
