// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/constants/app_strings.dart';
// import '../../../../core/theme/typography.dart';
// import '../../../../core/theme/insets.dart';
//
// class SocialLoginButton extends StatelessWidget {
//   final VoidCallback? onPressed;
//   final bool isLoading;
//
//   const SocialLoginButton({
//     super.key,
//     this.onPressed,
//     this.isLoading = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: Insets.buttonHeight,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.surfaceLight,
//           foregroundColor: AppColors.textPrimaryLight,
//           elevation: Insets.elevationLow,
//           side: BorderSide(
//             color: AppColors.inputBorderLight,
//             width: 1,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: Insets.buttonRadius,
//           ),
//           disabledBackgroundColor: AppColors.buttonDisabled,
//           disabledForegroundColor: AppColors.textSecondaryLight,
//         ),
//         child: isLoading
//             ? SizedBox(
//           width: 20.w,
//           height: 20.w,
//           child: CircularProgressIndicator(
//             strokeWidth: 2.w,
//             valueColor: const AlwaysStoppedAnimation<Color>(
//               AppColors.primaryBlue,
//             ),
//           ),
//         )
//             : Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Google logo placeholder - replace with actual Google logo
//             Container(
//               width: 20.w,
//               height: 20.w,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(2.r),
//                 color: AppColors.buttonGoogle,
//               ),
//               child: Center(
//                 child: Text(
//                   'G',
//                   style: TextStyle(
//                     color: AppColors.textOnPrimary,
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: Insets.md),
//             Text(
//               AppStrings.signInWithGoogle,
//               style: AppTypography.buttonMedium.copyWith(
//                 color: AppColors.textPrimaryLight,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }