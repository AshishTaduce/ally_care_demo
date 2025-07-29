import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTypography {
  // Base text style using Google Fonts Poppins
  static TextStyle get _baseTextStyle => GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
  );

  // Display Styles (Extra Large)
  static TextStyle get displayLarge => _baseTextStyle.copyWith(
    fontSize: 57.sp,
    fontWeight: FontWeight.w400,
    height: 1.12,
    letterSpacing: -0.25,
  );

  static TextStyle get displayMedium => _baseTextStyle.copyWith(
    fontSize: 45.sp,
    fontWeight: FontWeight.w400,
    height: 1.16,
  );

  static TextStyle get displaySmall => _baseTextStyle.copyWith(
    fontSize: 36.sp,
    fontWeight: FontWeight.w400,
    height: 1.22,
  );

  // Headline Styles
  static TextStyle get h1 => _baseTextStyle.copyWith(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static TextStyle get h2 => _baseTextStyle.copyWith(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    height: 1.29,
  );

  static TextStyle get h3 => _baseTextStyle.copyWith(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  static TextStyle get h4 => _baseTextStyle.copyWith(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle get h5 => _baseTextStyle.copyWith(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 1.44,
  );

  static TextStyle get h6 => _baseTextStyle.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  // Body Styles
  static TextStyle get bodyLarge => _baseTextStyle.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static TextStyle get bodyMedium => _baseTextStyle.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static TextStyle get bodySmall => _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
  );

  // Label Styles
  static TextStyle get labelLarge => _baseTextStyle.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static TextStyle get labelMedium => _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.5,
  );

  static TextStyle get labelSmall => _baseTextStyle.copyWith(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.5,
  );

  // Button Styles
  static TextStyle get buttonLarge => _baseTextStyle.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.1,
  );

  static TextStyle get buttonMedium => _baseTextStyle.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.29,
    letterSpacing: 0.1,
  );

  static TextStyle get buttonSmall => _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.1,
  );

  // Caption and Overline
  static TextStyle get caption => _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
  );

  static TextStyle get overline => _baseTextStyle.copyWith(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 1.5,
    textBaseline: TextBaseline.alphabetic,
  );

  // Special Component Styles
  static TextStyle get appBarTitle => _baseTextStyle.copyWith(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle get tabLabel => _baseTextStyle.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static TextStyle get cardTitle => _baseTextStyle.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextStyle get cardSubtitle => _baseTextStyle.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: AppColors.textSecondaryLight,
  );

  static TextStyle get inputLabel => _baseTextStyle.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.43,
  );

  static TextStyle get inputText => _baseTextStyle.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get inputHint => _baseTextStyle.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get errorText => _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.33,
    color: AppColors.error,
  );
}