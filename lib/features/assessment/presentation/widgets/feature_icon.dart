import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/insets.dart';
import '../../../../core/constants/app_colors.dart';

class FeatureIcon extends StatelessWidget {
  final String label;
  const FeatureIcon({Key? key, required this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: Insets.radiusLg * 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.grey400),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/images/illustrations/${label.replaceAll(" ", "_").toLowerCase()}.svg',
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} 