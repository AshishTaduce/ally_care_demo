import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/insets.dart';

class AuthFormContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const AuthFormContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? Insets.cardPaddingLarge,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: Insets.borderRadiusLg,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}