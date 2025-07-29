import 'package:ally_care_demo/core/theme/typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliver_snap/widgets/sliver_snap.dart';
import '../../data/assessment_model.dart';
import '../providers/assessment_provider.dart';
import '../../../../core/theme/insets.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/assessment_detail_header.dart';
import '../widgets/assessment_detail_body.dart';

class AssessmentDetailScreen extends ConsumerStatefulWidget {
  final AssessmentModel assessment;
  const AssessmentDetailScreen({super.key, required this.assessment});

  @override
  ConsumerState<AssessmentDetailScreen> createState() =>
      _AssessmentDetailScreenState();
}

class _AssessmentDetailScreenState
    extends ConsumerState<AssessmentDetailScreen> {
  late AssessmentModel _assessment;
  bool _isFavorite = false;
  bool _loading = false;
  bool isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _assessment = widget.assessment;
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorite_assessments') ?? [];
    setState(() {
      _isFavorite = favs.contains(_assessment.id);
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorite_assessments') ?? [];
    setState(() {
      if (_isFavorite) {
        favs.remove(_assessment.id);
        _isFavorite = false;
      } else {
        favs.add(_assessment.id);
        _isFavorite = true;
      }
    });
    await prefs.setStringList('favorite_assessments', favs);
    // Update local Hive cache for this assessment
    final updated = _assessment.copyWith(); // No change to model, but could add favorite field if needed
    await ref.read(assessmentServiceProvider).saveAssessmentLocally(updated);
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    final result = await ref.read(
      assessmentByIdProvider(_assessment.id).future,
    );
    setState(() {
      _assessment = result;
      _loading = false;
    });
    await _loadFavorite();
  }

  BorderRadius _getBorderRadius(bool collapsed) {
    return !collapsed
        ? BorderRadius.only(
            topLeft: Radius.circular(Insets.lg),
            topRight: Radius.circular(Insets.lg),
          )
        : BorderRadius.zero;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SliverSnap(
        onCollapseStateChanged: (collapsed, scrollingOffset, maxExtent) {
          setState(() {
            isCollapsed = collapsed;
          });
        },
        expandedBackgroundColor: Colors.transparent,
        backdropWidget: Hero(
          tag: _assessment.id,
          child: CachedNetworkImage(
            height: 270.h,
            imageUrl: _assessment.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseLight,
              highlightColor: AppColors.shimmerHighlightLight,
              child: Container(color: AppColors.shimmerBaseLight),
            ),
            errorWidget: (context, url, error) => Icon(Icons.broken_image),
          ),
        ),
        expandedContentHeight: Insets.verticalXxl * 5,
        expandedContent: AssessmentDetailHeader(assessment: _assessment),
        leading: IconButton(
          tooltip: 'Go back',
          icon: Container(
            padding: isCollapsed ? EdgeInsets.zero : EdgeInsets.all(8),
            decoration: isCollapsed
                ? null
                : BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(
              Icons.arrow_back,
              color: isCollapsed ? null : Colors.black,
              size: 14.r,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        collapsedContent: Row(
          children: [
            Text(
              _assessment.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.h6.copyWith(
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle Favorite',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(_isFavorite),
                color: _isFavorite ? AppColors.favoriteActive : AppColors.grey800,
              ),
            ),
            onPressed: _toggleFavorite,
          ),
        ],
        body: Material(
          elevation: 0,
          key: ValueKey(isCollapsed),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Insets.md * 1.5,
              vertical: Insets.lg,
            ),
            decoration: BoxDecoration(
              borderRadius: _getBorderRadius(isCollapsed),
            ),
            child: AssessmentDetailBody(
              assessment: _assessment,
              isCollapsed: isCollapsed,
            ),
          ),
        ),
      ),
    );
  }

}
