import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/theme/insets.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool enabled;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final void Function(String)? onChanged;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      enabled: enabled,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      style: AppTypography.bodyLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.bodyLarge.copyWith(
          color: Theme.of(context).hintColor,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: AppColors.textSecondaryLight,
          size: Insets.iconMd,
        ),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
          onTap: onSuffixIconTap,
          child: Icon(
            suffixIcon,
            color: AppColors.textSecondaryLight,
            size: Insets.iconMd,
          ),
        )
            : null,
        filled: true,
        fillColor: AppColors.inputFillLight,
        contentPadding: EdgeInsets.symmetric(
          horizontal: Insets.md,
          vertical: Insets.md,
        ),
        border: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: BorderSide(
            color: AppColors.grey300,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: BorderSide(
            color: AppColors.grey300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: const BorderSide(
            color: AppColors.inputBorderFocused,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: Insets.inputRadius,
          borderSide: BorderSide(
            color: AppColors.grey300,
            width: 1,
          ),
        ),
        errorStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.error,
        ),
      ),
    );
  }
}