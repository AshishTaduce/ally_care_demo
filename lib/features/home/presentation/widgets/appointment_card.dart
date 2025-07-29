import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ally_care_demo/core/theme/insets.dart';
import 'package:ally_care_demo/core/constants/app_colors.dart';
import '../../../appointment/data/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onTap;
  final bool isFromHome;
  final bool isBooked;
  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
    this.isFromHome = false,
    this.isBooked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _hexToColor(appointment.backgroundColor),
        borderRadius: Insets.borderRadiusMd,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: Insets.borderRadiusMd,
            child: Padding(
              padding: Insets.cardPadding,
              child: isFromHome
                  ? Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.grey400,
                              width: 1,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            radius: Insets.lg,
                            child: SvgPicture.asset(
                              appointment.iconSvg,
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ),
                        SizedBox(height: Insets.sm),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                appointment.title,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              if (!isFromHome) ...[
                                SizedBox(height: Insets.xs),
                                Text(
                                  appointment.priceText,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ],
                              if (isBooked && !isFromHome) ...[
                                SizedBox(height: Insets.xs),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: Insets.xs, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(Insets.radiusSm),
                                    border: Border.all(color: AppColors.success, width: 0.5),
                                  ),
                                  child: Text(
                                    'Booked',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.grey400,
                              width: 1,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            radius: 28,
                            child: SvgPicture.asset(
                              appointment.iconSvg,
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ),
                        SizedBox(width: Insets.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.title,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (!isFromHome) ...[
                                SizedBox(height: Insets.xs),
                                Text(
                                  appointment.priceText,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ],
                              if (isBooked && !isFromHome) ...[
                                SizedBox(height: Insets.xs),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: Insets.xs, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(Insets.radiusSm),
                                    border: Border.all(color: AppColors.success, width: 0.5),
                                  ),
                                  child: Text(
                                    'Booked',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          if (isFromHome && isBooked)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}
