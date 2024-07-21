import 'package:flutter/material.dart';
import 'package:project_login/Constants.dart';

class ContentDisplay {
  double textSize;
  double lineSpacing;
  String fontFamily;
  int textColor;
  int backgroundColor;

  ContentDisplay({
    required this.textSize,
    required this.lineSpacing,
    required this.fontFamily,
    required this.textColor,
    required this.backgroundColor,
  });

  ContentDisplay.defaults()
      : textSize = DEFAULT_TEXT_SZIE,
        lineSpacing = DEFAULT_LINE_SPACING,
        fontFamily = DEFAULT_FONT_FAMILY,
        textColor = DEFAULT_TEXT_COLOR,
        backgroundColor = DEFAULT_BACKGROUND_COLOR;
}
