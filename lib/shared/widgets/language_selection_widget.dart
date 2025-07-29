import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/insets.dart';
import '../models/language_model.dart';

class LanguageSelectorWidget extends StatefulWidget {
  final Language currentLanguage;
  final Function(Language)? onLanguageChanged;

  const LanguageSelectorWidget({
    super.key,
    required this.currentLanguage,
    this.onLanguageChanged,
  });

  @override
  State<LanguageSelectorWidget> createState() => _LanguageSelectorWidgetState();
}

class _LanguageSelectorWidgetState extends State<LanguageSelectorWidget> {
  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildLanguageBottomSheet(),
    );
  }

  Widget _buildLanguageBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Insets.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: Insets.sm),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Title
          Padding(
            padding: EdgeInsets.all(Insets.lg),
            child: Text(
              'Select Language',
              style: AppTypography.h6.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Language options
          ...AppLanguages.supportedLanguages.map(
                (language) => _buildLanguageOption(language),
          ),

          // Cancel button
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.lg),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: Insets.md),
                ),
                child: Text(
                  'Cancel',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(Language language) {
    final isSelected = language.code == widget.currentLanguage.code;

    return InkWell(
      onTap: () {
        widget.onLanguageChanged?.call(language);
        Navigator.pop(context);

        // Show a brief feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Language changed to ${language.name}'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.md,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            // Flag
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: AppColors.grey300,
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Text(
                  language.flag,
                  style: TextStyle(fontSize: 18.sp),
                ),
              ),
            ),

            SizedBox(width: Insets.md),

            // Language names
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.name,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  if (language.nativeName != language.name) ...[
                    SizedBox(height: 2.h),
                    Text(
                      language.nativeName,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Selected indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryBlue,
                size: Insets.iconMd,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showLanguageSelector,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.sm,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: Insets.xl,
        ),
        decoration: BoxDecoration(
          // color: widgets.isDarkBackground
          //     ? AppColors.textOnPrimary.withOpacity(0.2)
          //     : AppColors.grey100,
          borderRadius: Insets.borderRadiusSm,
          border: Border.all(
            color: AppColors.buttonBorderInactive,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.currentLanguage.flag,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
            SizedBox(width: Insets.sm,),
            Text(
              widget.currentLanguage.shortName,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondaryLight,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 22.w,
              color: AppColors.textSecondaryLight,
            ),
          ],
        ),
      ),
    );
  }
}