import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ally_care_demo/core/theme/insets.dart';
import 'package:ally_care_demo/core/theme/typography.dart';
import 'package:ally_care_demo/core/constants/app_colors.dart';
import 'package:ally_care_demo/shared/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final themeNotifier = ref.watch(themeProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTypography.h5.copyWith(
            color: AppColors.getTextPrimaryColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColors.getTextPrimaryColor(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Section
            _buildSectionHeader(context, 'Appearance', Icons.palette),
            SizedBox(height: Insets.md),
            _buildThemeSection(context, ref, currentTheme, themeNotifier),
            SizedBox(height: Insets.xl),

            // Notifications Section
            _buildSectionHeader(context, 'Notifications', Icons.notifications),
            SizedBox(height: Insets.md),
            _buildNotificationSection(context),
            SizedBox(height: Insets.xl),

            // Privacy Section
            _buildSectionHeader(context, 'Privacy & Security', Icons.security),
            SizedBox(height: Insets.md),
            _buildPrivacySection(context),
            SizedBox(height: Insets.xl),

            // About Section
            _buildSectionHeader(context, 'About', Icons.info),
            SizedBox(height: Insets.md),
            _buildAboutSection(context),
            SizedBox(height: Insets.xl),

            // Support Section
            _buildSectionHeader(context, 'Support', Icons.help),
            SizedBox(height: Insets.md),
            _buildSupportSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primaryBlue,
          size: 24,
        ),
        SizedBox(width: Insets.sm),
        Text(
          title,
          style: AppTypography.h6.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimaryColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSection(
    BuildContext context,
    WidgetRef ref,
    AppThemeMode currentTheme,
    ThemeNotifier themeNotifier,
  ) {
    return Card(
      child: Column(
        children: [
          // Current Theme Display
            ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
              child: Icon(
                themeNotifier.getThemeIcon(),
                color: AppColors.primaryBlue,
                size: 20,
              ),
            ),
            title: Text(
              'Current Theme',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.getTextPrimaryColor(context),
              ),
            ),
            subtitle: Text(
              themeNotifier.getThemeDisplayName(),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.getTextSecondaryColor(context),
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: AppColors.getIconColor(context),
            ),
            onTap: () => _showThemeSelectionDialog(context, ref, currentTheme, themeNotifier),
          ),
          Divider(height: 1),
          // Theme Options
          _buildThemeOption(
            context,
            'Light Theme',
            'Clean and bright interface',
            Icons.light_mode,
            AppThemeMode.light,
            currentTheme,
            themeNotifier,
          ),
          _buildThemeOption(
            context,
            'Dark Theme',
            'Easy on the eyes',
            Icons.dark_mode,
            AppThemeMode.dark,
            currentTheme,
            themeNotifier,
          ),
          _buildThemeOption(
            context,
            'System Theme',
            'Follows your device settings',
            Icons.brightness_auto,
            AppThemeMode.system,
            currentTheme,
            themeNotifier,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    AppThemeMode themeMode,
    AppThemeMode currentTheme,
    ThemeNotifier themeNotifier,
  ) {
    final isSelected = currentTheme == themeMode;
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isSelected 
            ? AppColors.primaryBlue.withOpacity(0.1)
            : AppColors.getSurfaceColor(context).withOpacity(0.5),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primaryBlue : AppColors.getIconColor(context),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: AppColors.getTextPrimaryColor(context),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.getTextSecondaryColor(context),
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: AppColors.primaryBlue,
              size: 24,
            )
          : null,
      onTap: () => themeNotifier.setTheme(themeMode),
    );
  }

  Widget _buildNotificationSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildSwitchTile(
            context,
            'Push Notifications',
            'Receive notifications for appointments and updates',
            Icons.notifications,
            true,
            (value) {
              // TODO: Implement notification toggle
            },
          ),
          Divider(height: 1),
          _buildSwitchTile(
            context,
            'Email Notifications',
            'Receive updates via email',
            Icons.email,
            false,
            (value) {
              // TODO: Implement email notification toggle
            },
          ),
          Divider(height: 1),
          _buildSwitchTile(
            context,
            'Reminder Notifications',
            'Get reminded about upcoming appointments',
            Icons.alarm,
            true,
            (value) {
              // TODO: Implement reminder toggle
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildListTile(
            context,
            'Privacy Policy',
            'Read our privacy policy',
            Icons.privacy_tip,
            () {
              // TODO: Navigate to privacy policy
            },
          ),
          Divider(height: 1),
          _buildListTile(
            context,
            'Terms of Service',
            'Read our terms of service',
            Icons.description,
            () {
              // TODO: Navigate to terms of service
            },
          ),
          Divider(height: 1),
          _buildListTile(
            context,
            'Data Usage',
            'Manage your data preferences',
            Icons.data_usage,
            () {
              // TODO: Navigate to data usage settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildListTile(
            context,
            'App Version',
            '1.0.0',
            Icons.info,
            null,
            showTrailing: false,
          ),
          Divider(height: 1),
          _buildListTile(
            context,
            'About Ally Care',
            'Learn more about our app',
            Icons.medical_services,
            () {
              // TODO: Navigate to about page
            },
          ),
          Divider(height: 1),
          _buildListTile(
            context,
            'Licenses',
            'Open source licenses',
            Icons.attribution_rounded,
            () {
              // TODO: Show licenses
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildListTile(
            context,
            'Help & Support',
            'Get help and contact support',
            Icons.help,
            () {
              // TODO: Navigate to help page
            },
          ),
          Divider(height: 1),
          _buildListTile(
            context,
            'Contact Us',
            'Reach out to our team',
            Icons.contact_support,
            () {
              // TODO: Navigate to contact page
            },
          ),
          Divider(height: 1),
          _buildListTile(
            context,
            'Feedback',
            'Share your feedback with us',
            Icons.feedback,
            () {
              // TODO: Navigate to feedback page
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.getSurfaceColor(context).withOpacity(0.5),
        child: Icon(
          icon,
          color: AppColors.getIconColor(context),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.getTextPrimaryColor(context),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.getTextSecondaryColor(context),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback? onTap, {
    bool showTrailing = true,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.getSurfaceColor(context).withOpacity(0.5),
        child: Icon(
          icon,
          color: AppColors.getIconColor(context),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.getTextPrimaryColor(context),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.getTextSecondaryColor(context),
        ),
      ),
      trailing: showTrailing
          ? Icon(
              Icons.chevron_right,
              color: AppColors.getIconColor(context),
            )
          : null,
      onTap: onTap,
    );
  }

  void _showThemeSelectionDialog(
    BuildContext context,
    WidgetRef ref,
    AppThemeMode currentTheme,
    ThemeNotifier themeNotifier,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Choose Theme',
            style: AppTypography.h5.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimaryColor(context),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeDialogOption(
                context,
                'Light Theme',
                'Clean and bright interface',
                Icons.light_mode,
                AppThemeMode.light,
                currentTheme,
                themeNotifier,
              ),
              SizedBox(height: Insets.sm),
              _buildThemeDialogOption(
                context,
                'Dark Theme',
                'Easy on the eyes',
                Icons.dark_mode,
                AppThemeMode.dark,
                currentTheme,
                themeNotifier,
              ),
              SizedBox(height: Insets.sm),
              _buildThemeDialogOption(
                context,
                'System Theme',
                'Follows your device settings',
                Icons.brightness_auto,
                AppThemeMode.system,
                currentTheme,
                themeNotifier,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.getTextSecondaryColor(context)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeDialogOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    AppThemeMode themeMode,
    AppThemeMode currentTheme,
    ThemeNotifier themeNotifier,
  ) {
    final isSelected = currentTheme == themeMode;
    
    return InkWell(
      onTap: () {
        themeNotifier.setTheme(themeMode);
        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(Insets.radiusMd),
      child: Container(
        padding: EdgeInsets.all(Insets.md),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryBlue.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Insets.radiusMd),
          border: Border.all(
            color: isSelected 
                ? AppColors.primaryBlue
                : AppColors.getDividerColor(context),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlue : AppColors.getIconColor(context),
              size: 24,
            ),
            SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimaryColor(context),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.getTextSecondaryColor(context),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryBlue,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
} 