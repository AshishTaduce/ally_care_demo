import 'package:flutter/material.dart';
import 'package:ally_care_demo/core/constants/app_colors.dart';
import 'package:ally_care_demo/core/theme/insets.dart';
import 'package:ally_care_demo/core/theme/typography.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
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
              '1. Acceptance of Terms',
              'By accessing and using the Ally Care application, you accept and agree to be bound by the terms and provision of this agreement.',
            ),
            _buildSection(
              '2. Use License',
              'Permission is granted to temporarily download one copy of the application for personal, non-commercial transitory viewing only.',
            ),
            _buildSection(
              '3. Disclaimer',
              'The materials on Ally Care\'s application are provided on an \'as is\' basis. Ally Care makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.',
            ),
            _buildSection(
              '4. Limitations',
              'In no event shall Ally Care or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on Ally Care\'s application.',
            ),
            _buildSection(
              '5. Accuracy of Materials',
              'The materials appearing on Ally Care\'s application could include technical, typographical, or photographic errors. Ally Care does not warrant that any of the materials on its application are accurate, complete or current.',
            ),
            _buildSection(
              '6. Links',
              'Ally Care has not reviewed all of the sites linked to its application and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by Ally Care of the site.',
            ),
            _buildSection(
              '7. Modifications',
              'Ally Care may revise these terms of service for its application at any time without notice. By using this application you are agreeing to be bound by the then current version of these Terms and Conditions of Use.',
            ),
            _buildSection(
              '8. Governing Law',
              'These terms and conditions are governed by and construed in accordance with the laws and you irrevocably submit to the exclusive jurisdiction of the courts in that location.',
            ),
            SizedBox(height: Insets.xl),
            Container(
              padding: EdgeInsets.all(Insets.lg),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Insets.radiusMd),
                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primaryBlue,
                        size: 24,
                      ),
                      SizedBox(width: Insets.sm),
                      Text(
                        'Last Updated',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Insets.sm),
                  Text(
                    'December 2024',
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