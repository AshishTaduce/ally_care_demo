import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/theme/insets.dart';

class ProfileImagePicker extends StatelessWidget {
  final Function(File?) onImageSelected;
  final File? selectedImage;

  const ProfileImagePicker({
    super.key,
    required this.onImageSelected,
    this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile image container
        GestureDetector(
          onTap: () => _showImagePickerBottomSheet(context),
          child: Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(50.r),
              border: Border.all(
                color: AppColors.inputBorderLight,
                width: 2,
              ),
            ),
            child: selectedImage != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(48.r),
              child: Image.file(
                selectedImage!,
                fit: BoxFit.cover,
              ),
            )
                : Icon(
              Icons.person_add_alt_1_outlined,
              size: 40.w,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ),

        SizedBox(height: Insets.sm),

        // Add photo text (optional)
        Text(
          'Add Photo (Optional)',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Insets.radiusLg),
        ),
      ),
      builder: (context) => Container(
        padding: Insets.modalPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            SizedBox(height: Insets.lg),

            // Title
            Text(
              AppStrings.profilePicture,
              style: AppTypography.h6.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: Insets.lg),

            // Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Camera option
                _buildImageOption(
                  context: context,
                  icon: Icons.camera_alt_outlined,
                  label: AppStrings.takePicture,
                  onTap: () => _pickImage(context, ImageSource.camera),
                ),

                // Gallery option
                _buildImageOption(
                  context: context,
                  icon: Icons.photo_library_outlined,
                  label: AppStrings.chooseFromGallery,
                  onTap: () => _pickImage(context, ImageSource.gallery),
                ),

                // Remove option (if image exists)
                if (selectedImage != null)
                  _buildImageOption(
                    context: context,
                    icon: Icons.delete_outline,
                    label: AppStrings.removeImage,
                    onTap: () => _removeImage(context),
                    isDestructive: true,
                  ),
              ],
            ),

            SizedBox(height: Insets.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Insets.md),
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColors.error.withOpacity(0.1)
              : AppColors.primaryBlue.withOpacity(0.1),
          borderRadius: Insets.borderRadiusMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: Insets.iconXl,
              color: isDestructive
                  ? AppColors.error
                  : AppColors.primaryBlue,
            ),
            SizedBox(height: Insets.xs),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: isDestructive
                    ? AppColors.error
                    : AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    Navigator.pop(context);

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        onImageSelected(File(image.path));
      }
    } catch (e) {
      _showErrorSnackBar(context, AppStrings.imageUploadFailed);
    }
  }

  void _removeImage(BuildContext context) {
    Navigator.pop(context);
    onImageSelected(null);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}