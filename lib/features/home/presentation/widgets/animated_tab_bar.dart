import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/theme/insets.dart';

class HomeTabBar extends StatefulWidget {
  final TabController tabController;
  final void Function(int newIndex) updateTab;
  const HomeTabBar({
    super.key,
    required this.tabController, required this.updateTab,
  });

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: Insets.borderRadiusRound,
        border: Border.all(color: Color(0xFFf1f1f9)),
        color: AppColors.tabBackground
      ),
      padding: EdgeInsets.all(Insets.xs),

      child: TabBar(
        controller: widget.tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        onTap: (newIndex) => setState(() {
          widget.updateTab(newIndex);
        }),
        tabs: [
          _buildAnimatedTab(
            context,
            label: 'My Assessments',
          ),
          _buildAnimatedTab(
            context,
            label: 'My Appointments',
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTab(
      BuildContext context, {
        required String label,
      }) {

    return Tab(
      height: 37.w,
      child: Center(child: Text(label, style: AppTypography.tabLabel,)),
    );
  }
}