import 'package:ally_care_demo/core/theme/typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/insets.dart';
import '../../data/workout_routine_model.dart';
import '../providers/workout_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutSection extends ConsumerWidget {
  const WorkoutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workoutProvider);
    return Container(
      margin: EdgeInsets.only(top: Insets.xs),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Workout Routines',
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
          SizedBox(
            height: 120,
            child: state.isLoading
                ? Center(child: CircularProgressIndicator())
                : state.error != null
                ? Center(child: Text('Error: \\${state.error}'))
                : PageView.builder(
                    itemCount: state.workouts.length,
                    controller: PageController(
                      viewportFraction: .7,
                      keepPage: true,
                    ),
                    padEnds: false,
                    itemBuilder: (context, index) {
                      final workout = state.workouts[index];
                      return _WorkoutCard(workout: workout);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final WorkoutRoutine workout;
  const _WorkoutCard({required this.workout});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Insets.radiusLg),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Insets.radiusLg),
          border: Border.all(color: AppColors.grey400),
        ),
        margin: EdgeInsets.only(right: Insets.sm),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: CachedNetworkImage(
                imageUrl: workout.imageUrl,
                fit: BoxFit.fitHeight,
                height: 120,
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Insets.sm * 1.5,
                  horizontal: Insets.sm * 1.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            workout.title,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 4),
                    Text(
                      workout.type,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 10.sp,
                        color: AppColors.grey700,
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Insets.radiusLg),
                        border: Border.all(color: AppColors.grey400),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Insets.xs * 1.5,
                        horizontal: Insets.sm,
                      ),
                      child: Text(
                        'Lose Weight',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          'Difficulty: ',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                        Text(
                          workout.difficulty,
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.redAccent,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
