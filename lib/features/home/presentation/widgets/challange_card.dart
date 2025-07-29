import 'package:ally_care_demo/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/insets.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Insets.xs),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Challenges',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    SizedBox(width: Insets.md),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.textTertiaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        size: Insets.iconXs,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Insets.sm.h * 1.25),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: Insets.sm.h,
              horizontal: Insets.md.w,
            ).copyWith(right: 0),
            decoration: BoxDecoration(
              color: Color(0xFFC1EAD1),
              borderRadius: BorderRadius.circular(Insets.radiusXl),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/illustrations/challange.png',
                      width: MediaQuery.of(context).size.width * .4,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Today's Challenge!",
                            style: AppTypography.bodySmall.copyWith(
                              color: Color(0xFF2b7a71),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: Insets.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2b7a71),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Push Up 20x',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          SizedBox(height: Insets.sm.h * 1.25),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ), // Adjust radius as needed
                                  child: LinearProgressIndicator(
                                    value: 0.5, // 50% completion
                                    minHeight:
                                        10.0, // Height of the progress bar
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Color(0xffff88a5),
                                        ),
                                  ),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                            ],
                          ),
                          SizedBox(height: Insets.xs.h),

                          // Progress
                          const Text(
                            '10/20 Complete',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2E4A2E),
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: Insets.sm * 1.5),

                          ElevatedButton.icon(
                            onPressed: () {
                              // Handle continue action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Insets.radiusXl,
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.play_circle_fill_rounded,
                              size: Insets.iconSm,
                              color: AppColors.primaryBlue,
                            ),
                            label: Text(
                              'Continue',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
