import 'package:flutter/material.dart';
import 'package:ally_care_demo/core/constants/app_colors.dart';
import 'package:ally_care_demo/core/theme/insets.dart';
import 'package:ally_care_demo/core/theme/typography.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
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
            // Hero Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Insets.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryBlue,
                    AppColors.primaryBlue.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(Insets.radiusLg),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 64,
                  ),
                  SizedBox(height: Insets.md),
                  Text(
                    'Ally Care',
                    style: AppTypography.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Insets.sm),
                  Text(
                    'Your Health, Our Priority',
                    style: AppTypography.bodyLarge.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Insets.xl),

            // Mission Section
            _buildSection(
              'Our Mission',
              'To provide accessible, personalized healthcare solutions that empower individuals to take control of their well-being through innovative technology and compassionate care.',
              Icons.flag,
            ),

            // Vision Section
            _buildSection(
              'Our Vision',
              'To become the leading platform for preventive healthcare, making quality medical services accessible to everyone, everywhere.',
              Icons.visibility,
            ),

            // Values Section
            _buildSection(
              'Our Values',
              'We are committed to excellence, innovation, compassion, and integrity in everything we do. Your health and trust are our top priorities.',
              Icons.favorite_border,
            ),

            // Team Section
            _buildSection(
              'Our Team',
              'Our dedicated team of healthcare professionals, developers, and support staff work together to deliver the best possible experience for our users.',
              Icons.people,
            ),

            // Features Section
            _buildFeaturesSection(),

            // Contact Section
            _buildContactSection(),

            SizedBox(height: Insets.xl),
            Container(
              padding: EdgeInsets.all(Insets.lg),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Insets.radiusMd),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        color: AppColors.warning,
                        size: 24,
                      ),
                      SizedBox(width: Insets.sm),
                      Text(
                        'Trusted by Thousands',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Insets.sm),
                  Text(
                    'Join thousands of users who trust Ally Care for their healthcare needs.',
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

  Widget _buildSection(String title, String content, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: Insets.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primaryBlue,
                size: 28,
              ),
              SizedBox(width: Insets.sm),
              Text(
                title,
                style: AppTypography.h6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: Insets.md),
          Text(
            content,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.grey700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Padding(
      padding: EdgeInsets.only(bottom: Insets.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star,
                color: AppColors.primaryBlue,
                size: 28,
              ),
              SizedBox(width: Insets.sm),
              Text(
                'What We Offer',
                style: AppTypography.h6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: Insets.md),
          _buildFeatureItem('Easy Appointment Booking', 'Book appointments with healthcare professionals in just a few taps'),
          _buildFeatureItem('Health Assessments', 'Take comprehensive health assessments to understand your current status'),
          _buildFeatureItem('Progress Tracking', 'Monitor your health progress and track improvements over time'),
          _buildFeatureItem('24/7 Support', 'Get help whenever you need it with our round-the-clock support team'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: Insets.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 20,
          ),
          SizedBox(width: Insets.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey800,
                  ),
                ),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Padding(
      padding: EdgeInsets.only(bottom: Insets.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.contact_support,
                color: AppColors.primaryBlue,
                size: 28,
              ),
              SizedBox(width: Insets.sm),
              Text(
                'Get in Touch',
                style: AppTypography.h6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: Insets.md),
          _buildContactItem(Icons.email, 'Email', 'support@allycare.com'),
          _buildContactItem(Icons.phone, 'Phone', '+1 (555) 123-4567'),
          _buildContactItem(Icons.location_on, 'Address', '123 Health Street, Care City, CC 12345'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: Insets.sm),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.grey600,
            size: 20,
          ),
          SizedBox(width: Insets.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 