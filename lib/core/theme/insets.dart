import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Insets {
  // Base spacing scale
  static double get xs => 4.0.w;
  static double get sm => 8.0.w;
  static double get md => 16.0.w;
  static double get lg => 24.0.w;
  static double get xl => 32.0.w;
  static double get xxl => 48.0.w;
  static double get xxxl => 64.0.w;

  // Vertical spacing
  static double get verticalXs => 4.0.h;
  static double get verticalSm => 8.0.h;
  static double get verticalMd => 16.0.h;
  static double get verticalLg => 24.0.h;
  static double get verticalXl => 32.0.h;
  static double get verticalXxl => 48.0.h;

  // Screen padding
  static EdgeInsets get screenPadding => EdgeInsets.symmetric(horizontal: md);
  static EdgeInsets get screenPaddingWithBottom => EdgeInsets.fromLTRB(md, 0, md, md);
  static EdgeInsets get screenPaddingAll => EdgeInsets.all(md);

  // Card padding
  static EdgeInsets get cardPadding => EdgeInsets.all(md);
  static EdgeInsets get cardPaddingSmall => EdgeInsets.all(sm);
  static EdgeInsets get cardPaddingLarge => EdgeInsets.all(lg);

  // List item padding
  static EdgeInsets get listItemPadding => EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static EdgeInsets get listItemPaddingLarge => EdgeInsets.symmetric(horizontal: md, vertical: md);

  // Button padding
  static EdgeInsets get buttonPadding => EdgeInsets.symmetric(horizontal: lg, vertical: sm);
  static EdgeInsets get buttonPaddingSmall => EdgeInsets.symmetric(horizontal: md, vertical: xs);
  static EdgeInsets get buttonPaddingLarge => EdgeInsets.symmetric(horizontal: xl, vertical: md);

  // Input field padding
  static EdgeInsets get inputPadding => EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static EdgeInsets get inputContentPadding => EdgeInsets.symmetric(horizontal: md, vertical: 12.0.h);

  // App bar padding
  static EdgeInsets get appBarPadding => EdgeInsets.symmetric(horizontal: md);

  // Bottom navigation padding
  static EdgeInsets get bottomNavPadding => EdgeInsets.symmetric(horizontal: sm, vertical: xs);

  // Bottom navigation padding
  static EdgeInsets get tabPadding => EdgeInsets.symmetric(horizontal: md, vertical: xs);

  // Modal padding
  static EdgeInsets get modalPadding => EdgeInsets.all(lg);
  static EdgeInsets get modalPaddingLarge => EdgeInsets.all(xl);

  // Safe area padding
  static EdgeInsets get safeAreaPadding => EdgeInsets.only(top: 44.0.h, bottom: 34.0.h);

  // Border radius
  static double get radiusXs => 4.0.r;
  static double get radiusSm => 8.0.r;
  static double get radiusMd => 12.0.r;
  static double get radiusLg => 16.0.r;
  static double get radiusXl => 20.0.r;
  static double get radiusXxl => 24.0.r;
  static double get radiusRound => 999.0.r;

  // Border radius specific components
  static BorderRadius get borderRadiusXs => BorderRadius.circular(radiusXs);
  static BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);
  static BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);
  static BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);
  static BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);
  static BorderRadius get borderRadiusXxl => BorderRadius.circular(radiusXxl);
  static BorderRadius get borderRadiusRound => BorderRadius.circular(radiusRound);

  // Component specific radii
  static BorderRadius get buttonRadius => borderRadiusRound;
  static BorderRadius get cardRadius => borderRadiusMd;
  static BorderRadius get inputRadius => borderRadiusXl;
  static BorderRadius get modalRadius => BorderRadius.vertical(top: Radius.circular(radiusXl));

  // Icon sizes
  static double get iconXs => 16.0.w;
  static double get iconSm => 20.0.w;
  static double get iconMd => 24.0.w;
  static double get iconLg => 28.0.w;
  static double get iconXl => 32.0.w;
  static double get iconXxl => 48.0.w;

  // Avatar sizes
  static double get avatarSmall => 32.0.w;
  static double get avatarMedium => 48.0.w;
  static double get avatarLarge => 64.0.w;
  static double get avatarXLarge => 96.0.w;

  // Component heights
  static double get buttonHeight => 48.0.h;
  static double get buttonHeightSmall => 36.0.h;
  static double get buttonHeightLarge => 56.0.h;
  static double get inputHeight => 48.0.h;
  static double get appBarHeight => 56.0.h;
  static double get tabBarHeight => 48.0.h;
  static double get bottomNavHeight => 80.0.h;

  // Elevation
  static double get elevationNone => 0.0;
  static double get elevationLow => 2.0;
  static double get elevationMedium => 4.0;
  static double get elevationHigh => 8.0;
  static double get elevationVeryHigh => 16.0;
}