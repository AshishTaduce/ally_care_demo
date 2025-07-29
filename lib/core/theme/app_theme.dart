import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import 'typography.dart';
import 'insets.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        primaryContainer: AppColors.primaryContainer,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        surface: AppColors.surfaceLight,
        surfaceVariant: AppColors.surfaceVariantLight,
        background: AppColors.backgroundLight,
        error: AppColors.error,
        errorContainer: AppColors.errorContainer,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnSecondary,
        onTertiary: AppColors.textOnPrimary,
        onSurface: AppColors.textOnSurfaceLight,
        onSurfaceVariant: AppColors.textOnSurfaceVariantLight,
        onBackground: AppColors.textPrimaryLight,
        onError: AppColors.textOnPrimary,
        onErrorContainer: AppColors.errorOnContainer,
        outline: AppColors.dividerLight,
        outlineVariant: AppColors.grey300,
        shadow: AppColors.shadowLight,
        scrim: AppColors.shadowMedium,
        inverseSurface: AppColors.surfaceDark,
        inversePrimary: AppColors.primaryLight,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.appBarBackgroundLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: Insets.elevationLow,
        centerTitle: true,
        titleTextStyle: AppTypography.appBarTitle.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(
          color: AppColors.appBarIconLight,
          size: 24.sp,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.textPrimaryLight),
        displayMedium: AppTypography.displayMedium.copyWith(color: AppColors.textPrimaryLight),
        displaySmall: AppTypography.displaySmall.copyWith(color: AppColors.textPrimaryLight),
        headlineLarge: AppTypography.h1.copyWith(color: AppColors.textPrimaryLight),
        headlineMedium: AppTypography.h2.copyWith(color: AppColors.textPrimaryLight),
        headlineSmall: AppTypography.h3.copyWith(color: AppColors.textPrimaryLight),
        titleLarge: AppTypography.h4.copyWith(color: AppColors.textPrimaryLight),
        titleMedium: AppTypography.h5.copyWith(color: AppColors.textPrimaryLight),
        titleSmall: AppTypography.h6.copyWith(color: AppColors.textPrimaryLight),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimaryLight),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryLight),
        bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryLight),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.textPrimaryLight),
        labelMedium: AppTypography.labelMedium.copyWith(color: AppColors.textSecondaryLight),
        labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.textSecondaryLight),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: Insets.elevationLow,
          padding: Insets.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: Insets.buttonRadius,
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          backgroundColor: Colors.transparent,
          padding: Insets.buttonPadding,
          side: const BorderSide(color: AppColors.primaryBlue, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: Insets.buttonRadius,
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          backgroundColor: Colors.transparent,
          padding: Insets.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: Insets.buttonRadius,
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFillLight,
        contentPadding: Insets.inputContentPadding,
        border: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: const BorderSide(color: AppColors.inputBorderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: const BorderSide(color: AppColors.inputBorderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: const BorderSide(color: AppColors.inputBorderFocused, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: const BorderSide(color: AppColors.inputBorderError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: const BorderSide(color: AppColors.inputBorderError, width: 2),
        ),
        labelStyle: AppTypography.inputLabel.copyWith(color: AppColors.textSecondaryLight),
        hintStyle: AppTypography.inputHint.copyWith(color: AppColors.textTertiaryLight),
        errorStyle: AppTypography.errorText,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: Insets.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: Insets.cardRadius,
        ),
        margin: EdgeInsets.symmetric(vertical: Insets.xs),
        shadowColor: AppColors.shadowLight,
      ),

      // Bottom Navigation Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.bottomNavBackgroundLight,
        selectedItemColor: AppColors.bottomNavSelectedLight,
        unselectedItemColor: AppColors.bottomNavUnselectedLight,
        type: BottomNavigationBarType.fixed,
        elevation: Insets.elevationMedium,
        selectedLabelStyle: AppTypography.labelSmall.copyWith(color: AppColors.bottomNavSelectedLight),
        unselectedLabelStyle: AppTypography.labelSmall.copyWith(color: AppColors.bottomNavUnselectedLight),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primaryBlue,
        unselectedLabelColor: AppColors.inactiveTabLabel,
        labelStyle: AppTypography.tabLabel,
        unselectedLabelStyle: AppTypography.tabLabel,
        indicator: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(Insets.radiusRound),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.iconLight,
        size: Insets.iconMd,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 1,
        space: Insets.md,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.textOnPrimary,
        elevation: Insets.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Insets.radiusXl),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primaryBlue,
        linearTrackColor: AppColors.progressTrackLight,
        circularTrackColor: AppColors.progressTrackLight,
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.snackbarBackgroundLight,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.snackbarTextLight,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: Insets.borderRadiusSm,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.dialogBackgroundLight,
        elevation: Insets.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: Insets.borderRadiusLg,
        ),
        titleTextStyle: AppTypography.h5.copyWith(color: AppColors.textPrimaryLight),
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryLight),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.bottomSheetBackgroundLight,
        elevation: Insets.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: Insets.modalRadius,
        ),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.checkboxCheckedLight;
          }
          return AppColors.checkboxUncheckedLight;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textOnPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Insets.radiusXs),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.switchThumbCheckedLight;
          }
          return AppColors.switchThumbUncheckedLight;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.switchTrackCheckedLight;
          }
          return AppColors.switchTrackUncheckedLight;
        }),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.radioCheckedLight;
          }
          return AppColors.radioUncheckedLight;
        }),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.sliderThumbLight,
        inactiveTrackColor: AppColors.sliderTrackLight,
        thumbColor: AppColors.sliderThumbLight,
        overlayColor: AppColors.primaryBlue.withOpacity(0.2),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.chipBackgroundLight,
        selectedColor: AppColors.chipSelectedBackgroundLight,
        disabledColor: AppColors.grey300,
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryLight),
        secondaryLabelStyle: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryLight),
        padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Insets.radiusRound),
        ),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        textColor: AppColors.textPrimaryLight,
        iconColor: AppColors.iconLight,
        contentPadding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Insets.radiusMd),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        surface: AppColors.surfaceDark,
        surfaceVariant: AppColors.surfaceVariantDark,
        background: AppColors.backgroundDark,
        error: AppColors.error,
        errorContainer: AppColors.errorContainer,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnSecondary,
        onTertiary: AppColors.textOnPrimary,
        onSurface: AppColors.textOnSurfaceDark,
        onSurfaceVariant: AppColors.textOnSurfaceVariantDark,
        onBackground: AppColors.textPrimaryDark,
        onError: AppColors.textOnPrimary,
        onErrorContainer: AppColors.errorOnContainer,
        outline: AppColors.dividerDark,
        outlineVariant: AppColors.greyDark600,
        shadow: AppColors.shadowLightDark,
        scrim: AppColors.shadowMediumDark,
        inverseSurface: AppColors.surfaceLight,
        inversePrimary: AppColors.primaryLight,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.appBarBackgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: Insets.elevationLow,
        centerTitle: true,
        titleTextStyle: AppTypography.appBarTitle.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(
          color: AppColors.appBarIconDark,
          size: 24.sp,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.textPrimaryDark),
        displayMedium: AppTypography.displayMedium.copyWith(color: AppColors.textPrimaryDark),
        displaySmall: AppTypography.displaySmall.copyWith(color: AppColors.textPrimaryDark),
        headlineLarge: AppTypography.h1.copyWith(color: AppColors.textPrimaryDark),
        headlineMedium: AppTypography.h2.copyWith(color: AppColors.textPrimaryDark),
        headlineSmall: AppTypography.h3.copyWith(color: AppColors.textPrimaryDark),
        titleLarge: AppTypography.h4.copyWith(color: AppColors.textPrimaryDark),
        titleMedium: AppTypography.h5.copyWith(color: AppColors.textPrimaryDark),
        titleSmall: AppTypography.h6.copyWith(color: AppColors.textPrimaryDark),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
        bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryDark),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.textPrimaryDark),
        labelMedium: AppTypography.labelMedium.copyWith(color: AppColors.textSecondaryDark),
        labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.textSecondaryDark),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: Insets.elevationLow,
          padding: Insets.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: Insets.buttonRadius,
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          backgroundColor: Colors.transparent,
          padding: Insets.buttonPadding,
          side: const BorderSide(color: AppColors.primaryBlue, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: Insets.buttonRadius,
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          backgroundColor: Colors.transparent,
          padding: Insets.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: Insets.buttonRadius,
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFillDark,
        contentPadding: Insets.inputContentPadding,
        border: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: const BorderSide(color: AppColors.inputBorderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: const BorderSide(color: AppColors.inputBorderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: const BorderSide(color: AppColors.inputBorderFocusedDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: const BorderSide(color: AppColors.inputBorderErrorDark),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: const BorderSide(color: AppColors.inputBorderErrorDark, width: 2),
        ),
        labelStyle: AppTypography.inputLabel.copyWith(color: AppColors.textSecondaryDark),
        hintStyle: AppTypography.inputHint.copyWith(color: AppColors.textTertiaryDark),
        errorStyle: AppTypography.errorText,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: Insets.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: Insets.cardRadius,
        ),
        margin: EdgeInsets.symmetric(vertical: Insets.xs),
        shadowColor: AppColors.shadowLightDark,
      ),

      // Bottom Navigation Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.bottomNavBackgroundDark,
        selectedItemColor: AppColors.bottomNavSelectedDark,
        unselectedItemColor: AppColors.bottomNavUnselectedDark,
        type: BottomNavigationBarType.fixed,
        elevation: Insets.elevationMedium,
        selectedLabelStyle: AppTypography.labelSmall.copyWith(color: AppColors.bottomNavSelectedDark),
        unselectedLabelStyle: AppTypography.labelSmall.copyWith(color: AppColors.bottomNavUnselectedDark),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primaryBlue,
        unselectedLabelColor: AppColors.textSecondaryDark,
        labelStyle: AppTypography.tabLabel,
        unselectedLabelStyle: AppTypography.tabLabel,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        dividerColor: Colors.transparent,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.iconDark,
        size: Insets.iconMd,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
        space: Insets.md,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.textOnPrimary,
        elevation: Insets.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Insets.radiusXl),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primaryBlue,
        linearTrackColor: AppColors.progressTrackDark,
        circularTrackColor: AppColors.progressTrackDark,
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.snackbarBackgroundDark,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.snackbarTextDark,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: Insets.borderRadiusSm,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.dialogBackgroundDark,
        elevation: Insets.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: Insets.borderRadiusLg,
        ),
        titleTextStyle: AppTypography.h5.copyWith(color: AppColors.textPrimaryDark),
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.bottomSheetBackgroundDark,
        elevation: Insets.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: Insets.modalRadius,
        ),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.checkboxCheckedDark;
          }
          return AppColors.checkboxUncheckedDark;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textOnPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Insets.radiusXs),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.switchThumbCheckedDark;
          }
          return AppColors.switchThumbUncheckedDark;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.switchTrackCheckedDark;
          }
          return AppColors.switchTrackUncheckedDark;
        }),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.radioCheckedDark;
          }
          return AppColors.radioUncheckedDark;
        }),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.sliderThumbDark,
        inactiveTrackColor: AppColors.sliderTrackDark,
        thumbColor: AppColors.sliderThumbDark,
        overlayColor: AppColors.primaryBlue.withOpacity(0.2),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.chipBackgroundDark,
        selectedColor: AppColors.chipSelectedBackgroundDark,
        disabledColor: AppColors.greyDark600,
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
        secondaryLabelStyle: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryDark),
        padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Insets.radiusRound),
        ),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        textColor: AppColors.textPrimaryDark,
        iconColor: AppColors.iconDark,
        contentPadding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Insets.radiusMd),
        ),
      ),
    );
  }
}