import 'package:flutter/material.dart';

/// 앱에서 사용하는 색상들을 정의하는 클래스
class AppColors {
  // Primary Colors - Blue 계열 (의료/신뢰성)
  static const Color primary = Color(0xFF2196F3);        // Blue
  static const Color primaryLight = Color(0xFF64B5F6);   // Light Blue
  static const Color primaryDark = Color(0xFF1976D2);    // Dark Blue
  
  // Secondary Colors - Green 계열 (건강/자연)
  static const Color secondary = Color(0xFF4CAF50);      // Green
  static const Color secondaryLight = Color(0xFF81C784); // Light Green
  static const Color secondaryDark = Color(0xFF388E3C);  // Dark Green
  
  // Accent Colors
  static const Color accent = Color(0xFFFFC107);         // Amber
  static const Color accentLight = Color(0xFFFFD54F);    // Light Amber
  static const Color accentDark = Color(0xFFFFA000);     // Dark Amber
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);        // Green
  static const Color warning = Color(0xFFFF9800);        // Orange
  static const Color error = Color(0xFFF44336);          // Red
  static const Color info = Color(0xFF2196F3);           // Blue
  
  // Background Colors
  static const Color background = Color(0xFFF5F5F5);     // Light Grey
  static const Color backgroundDark = Color(0xFF121212); // Dark Background
  static const Color surface = Colors.white;             // White
  static const Color surfaceDark = Color(0xFF1E1E1E);    // Dark Surface
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);    // Almost Black
  static const Color textSecondary = Color(0xFF757575);  // Medium Grey
  static const Color textTertiary = Color(0xFF9E9E9E);   // Light Grey
  static const Color textDisabled = Color(0xFFBDBDBD);   // Very Light Grey
  static const Color textOnPrimary = Colors.white;       // White on Primary
  static const Color textOnSecondary = Colors.white;     // White on Secondary
  
  // Divider & Border Colors
  static const Color divider = Color(0xFFE0E0E0);        // Light Grey
  static const Color border = Color(0xFFCCCCCC);         // Medium Light Grey
  static const Color borderDark = Color(0xFF424242);     // Dark Border
  
  // Special Colors for Health Village
  static const Color hospital = Color(0xFF1976D2);       // Hospital Blue
  static const Color pharmacy = Color(0xFF388E3C);       // Pharmacy Green
  static const Color emergency = Color(0xFFD32F2F);      // Emergency Red
  static const Color medicine = Color(0xFF7B1FA2);       // Medicine Purple
  
  // Roulette Colors
  static const List<Color> rouletteColors = [
    Color(0xFFE91E63), // Pink
    Color(0xFF9C27B0), // Purple
    Color(0xFF673AB7), // Deep Purple
    Color(0xFF3F51B5), // Indigo
    Color(0xFF2196F3), // Blue
    Color(0xFF03A9F4), // Light Blue
    Color(0xFF00BCD4), // Cyan
    Color(0xFF009688), // Teal
    Color(0xFF4CAF50), // Green
    Color(0xFF8BC34A), // Light Green
    Color(0xFFCDDC39), // Lime
    Color(0xFFFFEB3B), // Yellow
    Color(0xFFFFC107), // Amber
    Color(0xFFFF9800), // Orange
    Color(0xFFFF5722), // Deep Orange
    Color(0xFF795548), // Brown
  ];
  
  // Shadow Colors
  static const Color shadow = Color(0x29000000);         // 16% Black
  static const Color shadowLight = Color(0x1A000000);    // 10% Black
  static const Color shadowDark = Color(0x3D000000);     // 24% Black
} 