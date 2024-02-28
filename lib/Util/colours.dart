import 'package:flutter/painting.dart';

/// Utility class to manage the colours that should be used across the application.
//
/// Below are a set of static const variables with pre-defined colour values to ensure everyone is using the same colours
/// across the application.
class Colours {
  /// Primary colour which is generally used majority of the time e.g. background colour.
  static const Color primary = Color(0xFF2D3444);

  /// Secondary colour which is used to highlight other areas of the UI.
  static const Color secondary = Color(0xFF0e1925);

  /// Accent colour used to emphasis an particular area of the UI.
  static const Color accent = Color(0xFF467cb9);

  /// Off background colour.
  static const Color backgroundOff = Color(0xFFFAF0F0);

  /// A general icon colour to display icons.
  static const Color icon = Color(0XFF91A2A8);

  static const Color greyText = Color(0xFFBDBDBD);
}