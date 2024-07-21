import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final fonts = [
  GoogleFonts.roboto,
  GoogleFonts.aBeeZee,
  GoogleFonts.pacifico,
  GoogleFonts.lobster,
  GoogleFonts.combo,
];

const double MIN_TEXT_SIZE = 5;
const double MAX_TEXT_SIZE = 30;
const double MIN_LINE_SPACING = 0.5;
const double MAX_LINE_SPACING = 5;
const double CHAPTER_ITEM_HEIGHT = 50;

const double DEFAULT_TEXT_SZIE = 13;
const double DEFAULT_LINE_SPACING = 2;
const String DEFAULT_FONT_FAMILY = 'Roboto';
const int DEFAULT_TEXT_COLOR = 0xFF000000; // black
const int DEFAULT_BACKGROUND_COLOR = 0xFFFFFFFF; // white

const String TEXT_SIZE_KEY = "TEXT_SIZE_KEY";
const String LINE_SPACING_KEY = "LINE_SPACING_KEY";
const String TEXT_COLOR_KEY = "TEXT_COLOR_KEY";
const String BACKGROUND_COLOR_KEY = "BACKGROUND_COLOR_KEY";
const String FONT_FAMILY_KEY = "FONT_FAMILY_KEY";
const String IS_TESTING_KEY = "isTesting";