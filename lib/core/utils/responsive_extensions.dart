import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  double width(double ratio) => screenWidth * ratio;
  double height(double ratio) => screenHeight * ratio;

  double sp(double size) {
    return size * (screenWidth / 375);
  }
}
