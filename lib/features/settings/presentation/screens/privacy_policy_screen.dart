import 'package:flutter/material.dart';
import 'package:ally_care_demo/core/constants/app_colors.dart';
import 'package:ally_care_demo/core/theme/insets.dart';
import 'package:ally_care_demo/core/theme/typography.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '1. Information We Collect',
              'We collect information you provide directly to us, such as when you create an account, book appointments, or contact us for support. This may include your name, email address, phone number, and health-related information.',
            ),
            _buildSection(
              '2. How We Use Your Information',
              'We use the information we collect to provide, maintain, and improve our services, communicate with you, and ensure the security of our platform.',
            ),
            _buildSection(
              '3. Information Sharing',
              'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy or as required by law.',
            ),
            _buildSection(
              '4. Data Security',
              'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
            ),
            _buildSection(
              '5. Your Rights',
              'You have the right to access, update, or delete your personal information. You can also opt out of certain communications and request a copy of your data.',
            ),
            _buildSection(
              '6. Cookies and Tracking',
              'We use cookies and similar technologies to enhance your experience, analyze usage patterns, and provide personalized content.',
            ),
            _buildSection(
              '7. Third-Party Services',
              'Our app may contain links to third-party services. We are not responsible for the privacy practices of these external services.',
            ),
            _buildSection(
              '8. Children\'s Privacy',
              'Our services are not intended for children under 13. We do not knowingly collect personal information from children under 13.',
            ),
            _buildSection(
              '9. Changes to This Policy',
              'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page.',
            ),
            _buildSection(
              '10. Contact Us',
              'If you have any questions about this privacy policy, please contact us at privacy@allycare.com.',
            ),
            SizedBox(height: Insets.xl),
            Container(
              padding: EdgeInsets.all(Insets.lg),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Insets.radiusMd),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.security,
                        color: AppColors.success,
                        size: 24,
                      ),
                      SizedBox(width: Insets.sm),
                      Text(
                        'Your Privacy Matters',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Insets.sm),
                  Text(
                    'We are committed to protecting your privacy and ensuring the security of your personal information.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.grey700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.h6.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: Insets.sm),
          Text(
            content,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.grey700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
} 