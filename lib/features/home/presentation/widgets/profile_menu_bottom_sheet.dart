import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/theme/insets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/routes/route_names.dart';
import 'package:go_router/go_router.dart';

class ProfileMenuBottomSheet extends StatelessWidget {
  final WidgetRef ref;

  const ProfileMenuBottomSheet({
    super.key,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Insets.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          SizedBox(height: Insets.lg),
          _buildMenuItem(
            context,
            icon: Icons.person_outline,
            title: 'View Profile',
            onTap: () {
              Navigator.pop(context);
              context.push(RouteNames.fullProfile);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              context.push(RouteNames.fullSettings);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            onTap: () {
              Navigator.pop(context);
              context.push(RouteNames.fullTermsAndConditions);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              Navigator.pop(context);
              context.push(RouteNames.fullPrivacyPolicy);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.info_outline,
            title: 'About Us',
            onTap: () {
              Navigator.pop(context);
              context.push(RouteNames.fullAboutUs);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.contact_support_outlined,
            title: 'Contact Us',
            onTap: () {
              Navigator.pop(context);
              context.push(RouteNames.fullContactUs);
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () async {
              Navigator.pop(context);
              try {
                await ref.read(authNotifierProvider.notifier).signOut();
                if (context.mounted) {
                  context.go(RouteNames.login);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error signing out: $e')),
                  );
                }
              }
            },
            isDestructive: true,
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + Insets.md),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: EdgeInsets.only(top: Insets.sm),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        bool isDestructive = false,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.md,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive
                  ? AppColors.error
                  : AppColors.primaryBlue,
              size: Insets.iconMd,
            ),
            SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                title,
                style: AppTypography.bodyLarge.copyWith(
                  color: isDestructive
                      ? AppColors.error
                      : null,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.grey400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppColors.dividerLight,
      indent: Insets.lg,
      endIndent: Insets.lg,
    );
  }
}