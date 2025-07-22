import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 앱에서 사용하는 텍스트 스타일들을 정의하는 클래스
class AppTextStyles {
  // Headline Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.bold,
    
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headline2 = TextStyle(
    fontSize: 28,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.bold,
    
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headline3 = TextStyle(
    fontSize: 24,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.bold,
    
    color: AppColors.textPrimary,
    letterSpacing: -0.25,
  );
  
  static const TextStyle headline4 = TextStyle(
    fontSize: 20,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    
    color: AppColors.textPrimary,
    letterSpacing: -0.25,
  );
  
  static const TextStyle headline5 = TextStyle(
    fontSize: 18,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );
  
  static const TextStyle headline6 = TextStyle(
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
  );
  
  // Subtitle Styles
  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
    
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
  );
  
  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
    
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
  );
  
  // Body Styles
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.normal,
    
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.5,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.normal,
    
    color: AppColors.textSecondary,
    letterSpacing: 0.25,
    height: 1.4,
  );
  
  // Button Styles
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    
    color: AppColors.textOnPrimary,
    letterSpacing: 1.25,
  );
  
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    
    color: AppColors.textOnPrimary,
    letterSpacing: 1.25,
  );
  
  // Caption & Overline
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.normal,
    
    color: AppColors.textTertiary,
    letterSpacing: 0.4,
  );
  
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
    
    color: AppColors.textTertiary,
    letterSpacing: 1.5,
  );
  
  // Special Styles for Health Village
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    
    color: AppColors.textOnPrimary,
    letterSpacing: 0,
  );
  
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.normal,
    
    color: AppColors.textSecondary,
    letterSpacing: 0.25,
  );
  
  static const TextStyle listTileTitle = TextStyle(
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
    
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
  );
  
  static const TextStyle listTileSubtitle = TextStyle(
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.normal,
    
    color: AppColors.textSecondary,
    letterSpacing: 0.25,
  );
  
  // Error & Success Styles
  static const TextStyle error = TextStyle(
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.normal,
    
    color: AppColors.error,
    letterSpacing: 0.25,
  );
  
  static const TextStyle success = TextStyle(
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.normal,
    
    color: AppColors.success,
    letterSpacing: 0.25,
  );
  
  static const TextStyle warning = TextStyle(
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.normal,
    
    color: AppColors.warning,
    letterSpacing: 0.25,
  );
  
  // Navigation Styles
  static const TextStyle bottomNavLabel = TextStyle(
    fontSize: 12,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
    
    letterSpacing: 0.4,
  );
  
  static const TextStyle tabLabel = TextStyle(
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    
    letterSpacing: 1.25,
  );
  
  // Input Styles
  static const TextStyle inputLabel = TextStyle(
    fontSize: 12,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.normal,
    
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
  );
  
  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.normal,
    
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
  
  static const TextStyle inputHint = TextStyle(
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.normal,
    
    color: AppColors.textTertiary,
    letterSpacing: 0.5,
  );
} 