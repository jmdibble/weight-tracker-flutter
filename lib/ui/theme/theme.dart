import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData defaultTheme = _buildDefaultTheme();

ThemeData _buildDefaultTheme() {
  final ThemeData base = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xffb8f512),
//    textTheme: GoogleFonts.josefinSansTextTheme(),
  );
  return base.copyWith(
    textTheme: _buildDefaultTextTheme(base.textTheme),
    primaryTextTheme: _buildDefaultTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildDefaultTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildDefaultTextTheme(TextTheme base) {
  return base.copyWith();
}
