import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/theme/insets.dart';

class HomeCommonWidgets {
  static Widget buildEmptyState(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
      }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppColors.primaryBlue.withOpacity(0.5),
          ),
          SizedBox(height: Insets.lg),
          Text(
            title,
            style: AppTypography.h5.copyWith(
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: Insets.sm),
          Text(
            subtitle,
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Loading grid widget
  static Widget buildLoadingGrid() {
    return ListView.separated(
      itemCount: 2,
      separatorBuilder: (context, index) => SizedBox(height: Insets.md),
      itemBuilder: (context, index) {
        return Container(
          height: 100.h,
          decoration: BoxDecoration(
            color: AppColors.shimmerBaseLight,
            borderRadius: Insets.borderRadiusMd,
          ),
          child: Row(
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                margin: EdgeInsets.all(Insets.sm),
                decoration: BoxDecoration(
                  color: AppColors.shimmerHighlightLight,
                  borderRadius: Insets.borderRadiusSm,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 16.h,
                      width: double.infinity,
                      margin: EdgeInsets.only(right: Insets.lg),
                      decoration: BoxDecoration(
                        color: AppColors.shimmerHighlightLight,
                        borderRadius: Insets.borderRadiusXs,
                      ),
                    ),
                    SizedBox(height: Insets.xs),
                    Container(
                      height: 12.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: AppColors.shimmerHighlightLight,
                        borderRadius: Insets.borderRadiusXs,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Error state widget
  static Widget buildErrorState(
      BuildContext context,
      String error,
      VoidCallback onRetry,
      ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          SizedBox(height: Insets.lg),
          Text(
            'Something went wrong',
            style: AppTypography.h6.copyWith(
              color: AppColors.error,
            ),
          ),
          SizedBox(height: Insets.sm),
          Text(
            'Please try again',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Insets.lg),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: AppTypography.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }
}