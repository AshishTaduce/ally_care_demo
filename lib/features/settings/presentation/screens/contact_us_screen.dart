import 'package:flutter/material.dart';
import 'package:ally_care_demo/core/constants/app_colors.dart';
import 'package:ally_care_demo/core/theme/insets.dart';
import 'package:ally_care_demo/core/theme/typography.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
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
            // Header Section
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
                    Icons.contact_support,
                    color: Colors.white,
                    size: 48,
                  ),
                  SizedBox(height: Insets.md),
                  Text(
                    'Get in Touch',
                    style: AppTypography.h4.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Insets.sm),
                  Text(
                    'We\'re here to help and answer any questions you might have.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: Insets.xl),

            // Contact Information
            _buildContactInfoSection(),

            SizedBox(height: Insets.xl),

            // Contact Form
            _buildContactFormSection(),

            SizedBox(height: Insets.xl),

            // FAQ Section
            _buildFAQSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: AppTypography.h5.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: Insets.md),
        _buildContactCard(
          Icons.email,
          'Email',
          'support@allycare.com',
          'We typically respond within 24 hours',
          () => _launchEmail(),
        ),
        SizedBox(height: Insets.md),
        _buildContactCard(
          Icons.phone,
          'Phone',
          '+1 (555) 123-4567',
          'Available Monday-Friday, 9 AM - 6 PM EST',
          () => _launchPhone(),
        ),
        SizedBox(height: Insets.md),
        _buildContactCard(
          Icons.location_on,
          'Address',
          '123 Health Street, Care City, CC 12345',
          'Visit us during business hours',
          () => _launchMaps(),
        ),
      ],
    );
  }

  Widget _buildContactCard(
    IconData icon,
    String title,
    String value,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Insets.radiusMd),
          border: Border.all(color: AppColors.grey300),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(Insets.md),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Insets.radiusMd),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryBlue,
                size: 24,
              ),
            ),
            SizedBox(width: Insets.md),
            Expanded(
              child: Column(
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
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey800,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.grey400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Send us a Message',
          style: AppTypography.h5.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: Insets.md),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: Insets.md),
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: Insets.md),
              _buildTextField(
                controller: _subjectController,
                label: 'Subject',
                icon: Icons.subject,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              SizedBox(height: Insets.md),
              _buildTextField(
                controller: _messageController,
                label: 'Message',
                icon: Icons.message,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  if (value.length < 10) {
                    return 'Message must be at least 10 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: Insets.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: Insets.lg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Insets.radiusMd),
                    ),
                  ),
                  child: _isSubmitting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: Insets.sm),
                            Text('Sending...'),
                          ],
                        )
                      : Text(
                          'Send Message',
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.grey600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Insets.radiusMd),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Insets.radiusMd),
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: AppTypography.h5.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: Insets.md),
        _buildFAQItem(
          'How do I book an appointment?',
          'You can book appointments through the app by navigating to the appointments section and selecting your preferred time slot.',
        ),
        _buildFAQItem(
          'What if I need to cancel my appointment?',
          'You can cancel your appointment through the app up to 24 hours before the scheduled time. Go to your profile and select the appointment you want to cancel.',
        ),
        _buildFAQItem(
          'How do I reset my password?',
          'You can reset your password by going to your profile settings and selecting "Change Password". A reset link will be sent to your email.',
        ),
        _buildFAQItem(
          'Is my health information secure?',
          'Yes, we take your privacy seriously. All your health information is encrypted and stored securely. We never share your data without your explicit consent.',
        ),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.grey800,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.md),
          child: Text(
            answer,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.grey700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      // Simulate form submission
      await Future.delayed(Duration(seconds: 2));
      
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thank you! Your message has been sent successfully.'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // Clear form
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
      }
    }
  }

  void _launchEmail() {
    // TODO: Implement email launch
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Email feature coming soon!')),
    );
  }

  void _launchPhone() {
    // TODO: Implement phone launch
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Phone feature coming soon!')),
    );
  }

  void _launchMaps() {
    // TODO: Implement maps launch
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Maps feature coming soon!')),
    );
  }
} 