import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/theme/insets.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSecondary;
  final IconData? icon;

  const AuthButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary
              ? Colors.transparent
              : AppColors.buttonPrimary,
          foregroundColor: isSecondary
              ? AppColors.primaryBlue
              : AppColors.textOnPrimary,
          elevation: isSecondary ? 0 : Insets.elevationLow,
          side: isSecondary
              ? const BorderSide(
            color: AppColors.primaryBlue,
            width: 1.5,
          )
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: Insets.buttonRadius,
          ),
          disabledBackgroundColor: AppColors.buttonDisabled,
          disabledForegroundColor: AppColors.textSecondaryLight,
        ),
        child: isLoading
            ? SizedBox(
          width: 20.w,
          height: 20.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            valueColor: AlwaysStoppedAnimation<Color>(
              isSecondary
                  ? AppColors.primaryBlue
                  : AppColors.textOnPrimary,
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: Insets.iconMd,
              ),
              SizedBox(width: Insets.sm),
            ],
            Text(
              text,
              style: AppTypography.buttonMedium.copyWith(
                color: isSecondary
                    ? AppColors.primaryBlue
                    : AppColors.textOnPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (text == 'Continue') ...[
              SizedBox(width: Insets.sm),
              Icon(
                Icons.arrow_forward,
                size: Insets.iconSm,
              ),
            ],
          ],
        ),
      ),
    );
  }
}