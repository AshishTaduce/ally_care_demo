import 'package:flutter/material.dart';
import 'package:ally_care_demo/core/theme/typography.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/insets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/assessment_model.dart';
import 'feature_icon.dart';
import 'instruction_list.dart';

class AssessmentDetailBody extends StatelessWidget {
  final AssessmentModel assessment;
  final bool isCollapsed;
  const AssessmentDetailBody({super.key, required this.assessment, required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    var fitguyGap = Insets.xxl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What do you get?',
          style: AppTypography.h6.copyWith(
            color: AppColors.buttonSecondary(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Insets.sm * 1.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FeatureIcon(label: 'Key Body Vitals'),
            FeatureIcon(label: 'Posture Analysis'),
            FeatureIcon(label: 'Body Composition'),
            FeatureIcon(label: 'Instant Reports'),
          ].map<Widget>((child) => Expanded(child: child)).toList(),
        ),
        SizedBox(height: Insets.xxxl),
        Text(
          'How we do it?',
          style: AppTypography.h6.copyWith(
            color: AppColors.buttonSecondary(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: Insets.sm),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -Insets.xxl * 1.75,
              right: Insets.xxl * 1.5,
              child: Image.asset(
                height: Insets.xxxl * 2,
                'assets/images/illustrations/workout_progress.png',
              ),
            ),
            Container(
              padding: Insets.screenPaddingAll,
              decoration: BoxDecoration(
                color: AppColors.grey50,
                border: Border.all(color: AppColors.e6e6e6),
                borderRadius: BorderRadius.circular(Insets.radiusXl),
              ),
              child: Column(
                children: [
                  Container(height: Insets.xxxl * 3 - fitguyGap),
                  Container(
                    padding: EdgeInsets.all(Insets.sm),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        Insets.radiusSm,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.verified_user,
                          color: AppColors.success,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'We do not store or share your personal data',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontSize: 11.sp,
                                  color: Color(0xff707070),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Insets.md),
                  InstructionList(
                    instructions: assessment.instructions,
                  ),
                ],
              ),
            ),
            Positioned(
              top: -fitguyGap,
              child: Image.asset(
                height: Insets.xxxl * 3,
                'assets/images/illustrations/fit_guy.png',
              ),
            ),
            Positioned(
              top: -Insets.sm * .75,
              left: Insets.xl * 1.5,
              child: SvgPicture.asset(
                'assets/images/illustrations/body_points.svg',
              ),
            ),
          ],
        ),
      ],
    );
  }
}