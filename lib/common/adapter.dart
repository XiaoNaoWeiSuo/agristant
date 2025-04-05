import 'package:flutter/material.dart';

class Adapt {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double physicalWidth = 0;
  static double physicalHeight = 0;
  static double dpr = 0;
  static double ratio = 1.0;
  static double statusBarHeight = 0;
  static double bottomHeight = 0;

  static void initialize(BuildContext context, {double uiWidth = 400}) {
    final mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    statusBarHeight = mediaQueryData.padding.top;
    bottomHeight = mediaQueryData.padding.bottom;
    ratio = screenWidth / uiWidth;
  }

  static pt(size) {
    return size * Adapt.ratio;
  }
}
