import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/theme/insets.dart';
import '../../../../shared/routes/route_names.dart';
import '../../../assessment/data/assessment_model.dart';
import 'package:shimmer/shimmer.dart';

class AssessmentCard extends StatelessWidget {
  final AssessmentModel assessment;

  const AssessmentCard({super.key, required this.assessment});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: Insets.borderRadiusMd,
      ),
      child: GestureDetector(
        onTap: () {
          context.push('${RouteNames.fullAssessments}/detail/${assessment.id}', extra: assessment);
        },
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 60, child: _buildAssessmentImage()),
              Expanded(flex: 65, child: _buildAssessmentDetails(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssessmentImage() {
    return Hero(
      tag: assessment.id,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Insets.radiusMd),
          bottomLeft: Radius.circular(Insets.radiusMd),
        ),
        clipBehavior: Clip.hardEdge,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: CachedNetworkImage(
            imageUrl: assessment.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseLight,
              highlightColor: AppColors.shimmerHighlightLight,
              child: Container(
                color: AppColors.shimmerBaseLight,
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }

  Widget _buildAssessmentDetails(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            assessment.title,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w900,
              color: Theme.of(context).brightness == Brightness.light ? AppColors.textTertiaryLight : AppColors.textTertiaryDark,
              letterSpacing: 0,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: Insets.xs.h),
          Text(
            assessment.description,
            style: AppTypography.bodySmall.copyWith(fontSize: 10.sp),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: Insets.md.h),
          _buildStartButton(context),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.play_circle_fill_rounded,
          size: Insets.iconLg,
          color: AppColors.primaryBlue,
        ),
        SizedBox(width: Insets.sm.w),
        Text(
          "Start",
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}