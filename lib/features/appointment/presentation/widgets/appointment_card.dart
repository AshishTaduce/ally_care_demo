import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ally_care_demo/core/theme/typography.dart';
import 'package:ally_care_demo/core/theme/insets.dart';
import 'package:ally_care_demo/core/constants/app_colors.dart';
import '../../data/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onTap;
  final bool isCompleted;
  final bool isUpcoming;
  const AppointmentCard({super.key, required this.appointment, this.onTap, this.isCompleted = false, this.isUpcoming = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCompleted
          ? AppColors.grey200
          : isUpcoming
              ? AppColors.success.withOpacity(0.08)
              : Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: Insets.borderRadiusMd),
      margin: EdgeInsets.symmetric(vertical: Insets.sm),
      child: InkWell(
        borderRadius: Insets.borderRadiusMd,
        onTap: onTap,
        child: Padding(
          padding: Insets.cardPadding,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                radius: 28,
                child: SvgPicture.asset(
                  appointment.iconSvg,
                  width: 32,
                  height: 32,
                ),
              ),
              SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.title,
                      style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      appointment.doctorName,
                      style: AppTypography.bodySmall,
                    ),
                    SizedBox(height: 4),
                    Text(
                      appointment.nextAvailableSlot,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.primaryBlue),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.check_circle, color: AppColors.success, size: 28),
                ),
              if (isUpcoming && !isCompleted)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.schedule, color: AppColors.primaryBlue, size: 28),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 