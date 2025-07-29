import 'package:flutter/material.dart';
import 'package:ally_care_demo/core/theme/typography.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/insets.dart';
import '../../data/assessment_model.dart';

class AssessmentDetailHeader extends StatelessWidget {
  final AssessmentModel assessment;
  const AssessmentDetailHeader({Key? key, required this.assessment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Insets.xl,
            vertical: Insets.lg,
          ).copyWith(bottom: Insets.xl.h * 1.5),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 65,
                      child: Text(
                        assessment.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.h3.copyWith(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black.withOpacity(0.7),
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(flex: 35, child: Center()),
                  ],
                ),
                SizedBox(height: Insets.xs),
                Container(
                  padding: EdgeInsets.all(Insets.xs),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(Insets.xl),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer,
                        size: Insets.iconXs,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${assessment.duration} min',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 