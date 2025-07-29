import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF255FD5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF90CAF9);
  static const Color primaryContainer = Color(0xFFE3F2FD);

  // Secondary Colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);
  static const Color secondaryContainer = Color(0xFFE0F2F1);

  // Tertiary Colors
  static const Color tertiary = Color(0xFFFF6B6B);
  static const Color tertiaryContainer = Color(0xFFFFEBEE);

  // Surface Colors - Light Theme
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF8F9FA);
  static const Color surfaceContainerLight = Color(0xFFF5F5F5);
  static const Color surfaceContainerHighLight = Color(0xFFEEEEEE);
  static const Color surfaceContainerHighestLight = Color(0xFFE0E0E0);

  // Surface Colors - Dark Theme
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantDark = Color(0xFF2C2C2C);
  static const Color surfaceContainerDark = Color(0xFF2D2D2D);
  static const Color surfaceContainerHighDark = Color(0xFF3A3A3A);
  static const Color surfaceContainerHighestDark = Color(0xFF424242);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFAFCFF);
  static const Color backgroundDark = Color(0xFF121212);

  // Card Colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2C2C2C);

  // Text Colors - Light Theme
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color textTertiaryLight = Color(0xFF232f58);
  static const Color textDisabledLight = Color(0xFFCCCCCC);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFF000000);
  static const Color textOnSurfaceLight = Color(0xFF1A1A1A);
  static const Color textOnSurfaceVariantLight = Color(0xFF666666);

  // Text Colors - Dark Theme
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textTertiaryDark = Color(0xFF808080);
  static const Color textDisabledDark = Color(0xFF4D4D4D);
  static const Color textOnSurfaceDark = Color(0xFFFFFFFF);
  static const Color textOnSurfaceVariantDark = Color(0xFFB3B3B3);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successContainer = Color(0xFFE8F5E8);
  static const Color successOnContainer = Color(0xFF1B5E20);
  
  static const Color warning = Color(0xFFFF9800);
  static const Color warningContainer = Color(0xFFFFF3E0);
  static const Color warningOnContainer = Color(0xFFE65100);
  
  static const Color error = Color(0xFFF44336);
  static const Color errorContainer = Color(0xFFFFEBEE);
  static const Color errorOnContainer = Color(0xFFB71C1C);
  
  static const Color info = Color(0xFF2196F3);
  static const Color infoContainer = Color(0xFFE3F2FD);
  static const Color infoOnContainer = Color(0xFF0D47A1);

  // Neutral Colors - Light Theme
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Neutral Colors - Dark Theme
  static const Color greyDark50 = Color(0xFF2A2A2A);
  static const Color greyDark100 = Color(0xFF3A3A3A);
  static const Color greyDark200 = Color(0xFF4A4A4A);
  static const Color greyDark300 = Color(0xFF5A5A5A);
  static const Color greyDark400 = Color(0xFF6A6A6A);
  static const Color greyDark500 = Color(0xFF7A7A7A);
  static const Color greyDark600 = Color(0xFF8A8A8A);
  static const Color greyDark700 = Color(0xFF9A9A9A);
  static const Color greyDark800 = Color(0xFFAAAAAA);
  static const Color greyDark900 = Color(0xFFBABABA);

  // Input Field Colors - Light Theme
  static const Color inputFillLight = Color(0xFFF8F9FA);
  static const Color inputBorderLight = Color(0xFFE1E5E9);
  static const Color inputBorderFocused = primaryBlue;
  static const Color inputBorderError = error;

  // Input Field Colors - Dark Theme
  static const Color inputFillDark = Color(0xFF2C2C2C);
  static const Color inputBorderDark = Color(0xFF404040);
  static const Color inputBorderFocusedDark = primaryBlue;
  static const Color inputBorderErrorDark = error;

  // Button Colors
  static const Color buttonPrimary = primaryBlue;
  static const Color buttonPrimaryContainer = primaryContainer;
  static Color buttonSecondary (BuildContext context) => Theme.of(context).brightness == Brightness.light ? Color(0xFF232F58) : Color(
      0xFFC7C7FF);
  static const Color buttonSecondaryContainer = Color(0xFFE8EAF6);
  static const Color buttonDisabled = Color(0xFFE0E0E0);
  static const Color buttonDisabledText = Color(0xFF9E9E9E);
  static const Color buttonBorderInactive = Color(0xFFEAEAEA);

  // Tab Colors
  static const Color activeTabLabel = Colors.white;
  static const Color inactiveTabLabel = Color(0xFF6B6B6B);
  static const Color tabBackground = Color(0xFFF1F1F9);
  static const Color tabBackgroundDark = Color(0xFF2A2A2A);

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
  static const Color shadowLightDark = Color(0x1AFFFFFF);
  static const Color shadowMediumDark = Color(0x33FFFFFF);
  static const Color shadowDarkDark = Color(0x4DFFFFFF);

  // Shimmer Colors - Light Theme
  static const Color shimmerBaseLight = Color(0xFFE0E0E0);
  static const Color shimmerHighlightLight = Color(0xFFF5F5F5);

  // Shimmer Colors - Dark Theme
  static const Color shimmerBaseDark = Color(0xFF2C2C2C);
  static const Color shimmerHighlightDark = Color(0xFF404040);

  // Divider Colors
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF404040);

  // Icon Colors - Light Theme
  static const Color iconLight = Color(0xFF757575);
  static const Color iconOnSurfaceLight = Color(0xFF1A1A1A);
  static const Color iconOnSurfaceVariantLight = Color(0xFF666666);

  // Icon Colors - Dark Theme
  static const Color iconDark = Color(0xFFB3B3B3);
  static const Color iconOnSurfaceDark = Color(0xFFFFFFFF);
  static const Color iconOnSurfaceVariantDark = Color(0xFFB3B3B3);

  // App Bar Colors
  static const Color appBarBackgroundLight = Color(0xFFFFFFFF);
  static const Color appBarBackgroundDark = Color(0xFF1E1E1E);
  static const Color appBarIconLight = Color(0xFF3A3937);
  static const Color appBarIconDark = Color(0xFFFFFFFF);

  // Bottom Navigation Colors
  static const Color bottomNavBackgroundLight = surfaceLight;
  static const Color bottomNavBackgroundDark = surfaceDark;
  static const Color bottomNavSelectedLight = primaryBlue;
  static const Color bottomNavSelectedDark = primaryBlue;
  static const Color bottomNavUnselectedLight = iconLight;
  static const Color bottomNavUnselectedDark = iconDark;

  // Dialog Colors
  static const Color dialogBackgroundLight = surfaceLight;
  static const Color dialogBackgroundDark = surfaceDark;

  // Bottom Sheet Colors
  static const Color bottomSheetBackgroundLight = surfaceLight;
  static const Color bottomSheetBackgroundDark = surfaceDark;

  // Snackbar Colors
  static const Color snackbarBackgroundLight = Color(0xFF323232);
  static const Color snackbarBackgroundDark = Color(0xFFE0E0E0);
  static const Color snackbarTextLight = Color(0xFFFFFFFF);
  static const Color snackbarTextDark = Color(0xFF000000);

  // Progress Indicator Colors
  static const Color progressTrackLight = grey200;
  static const Color progressTrackDark = grey700;

  // Checkbox Colors
  static const Color checkboxUncheckedLight = grey400;
  static const Color checkboxUncheckedDark = grey600;
  static const Color checkboxCheckedLight = primaryBlue;
  static const Color checkboxCheckedDark = primaryBlue;

  // Switch Colors
  static const Color switchTrackUncheckedLight = grey300;
  static const Color switchTrackUncheckedDark = grey600;
  static const Color switchTrackCheckedLight = primaryLight;
  static const Color switchTrackCheckedDark = primaryDark;
  static const Color switchThumbUncheckedLight = grey400;
  static const Color switchThumbUncheckedDark = grey500;
  static const Color switchThumbCheckedLight = primaryBlue;
  static const Color switchThumbCheckedDark = primaryBlue;

  // Radio Button Colors
  static const Color radioUncheckedLight = grey400;
  static const Color radioUncheckedDark = grey600;
  static const Color radioCheckedLight = primaryBlue;
  static const Color radioCheckedDark = primaryBlue;

  // Slider Colors
  static const Color sliderTrackLight = grey300;
  static const Color sliderTrackDark = grey600;
  static const Color sliderThumbLight = primaryBlue;
  static const Color sliderThumbDark = primaryBlue;

  // Chip Colors
  static const Color chipBackgroundLight = grey100;
  static const Color chipBackgroundDark = grey800;
  static const Color chipSelectedBackgroundLight = primaryContainer;
  static const Color chipSelectedBackgroundDark = primaryDark;

  // Favorite Colors
  static const Color favoriteActive = Color(0xFFFF6B6B);
  static const Color favoriteInactive = Color(0xFFBDBDBD);

  // Gradient Colors
  static const Color gradientStart = Color(0xFF4285F4);
  static const Color gradientEnd = Color(0xFF1565C0);
  static const Color gradientStartDark = Color(0xFF1E3A8A);
  static const Color gradientEndDark = Color(0xFF0F172A);

  // Legacy Colors (for backward compatibility)
  static const Color e6e6e6 = Color(0xFFE6E6E6);
  static const Color fafcff = Color(0xFFFAFCFF);

  // Theme-aware color getters
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? surfaceLight 
        : surfaceDark;
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? backgroundLight 
        : backgroundDark;
  }

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? cardLight 
        : cardDark;
  }

  static Color getTextPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? textPrimaryLight 
        : textPrimaryDark;
  }

  static Color getTextSecondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? textSecondaryLight 
        : textSecondaryDark;
  }

  static Color getTextTertiaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? textTertiaryLight 
        : textTertiaryDark;
  }

  static Color getIconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? iconLight 
        : iconDark;
  }

  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? dividerLight 
        : dividerDark;
  }

  static Color getInputFillColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? inputFillLight 
        : inputFillDark;
  }

  static Color getInputBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? inputBorderLight 
        : inputBorderDark;
  }

  static Color getShadowColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? shadowLight 
        : shadowLightDark;
  }

  static Color getShimmerBaseColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? shimmerBaseLight 
        : shimmerBaseDark;
  }

  static Color getShimmerHighlightColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? shimmerHighlightLight 
        : shimmerHighlightDark;
  }
}