// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/constants/app_strings.dart';
// import '../../../../core/theme/typography.dart';
// import '../../../../core/theme/insets.dart';
// import '../../../../core/utils/validators.dart';
// import '../providers/auth_provider.dart';
// import '../widgets/auth_text_field.dart';
// import '../widgets/auth_button.dart';
// import '../widgets/auth_form_container.dart';
//
// class ForgotPasswordScreen extends ConsumerStatefulWidget {
//   const ForgotPasswordScreen({super.key});
//
//   @override
//   ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }
//
// class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   late final authState;
//
//   bool _isEmailSent = false;
//
//   @override
//   void initState() {
//     authState = ref.watch(authNotifierProvider);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }
//
//   void _handleResetPassword() {
//     if (_formKey.currentState?.validate() ?? false) {
//       ref.read(authNotifierProvider.notifier).resetPassword(
//         email: _emailController.text.trim(),
//       );
//     }
//   }
//
//   void _navigateBack() {
//     context.pop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     // Listen to auth state changes
//     ref.listen<AuthState>(authNotifierProvider, (previous, next) {
//       next.when(
//         initial: () {},
//         loading: () {},
//         authenticated: (user) {},
//         unauthenticated: () {},
//         error: (message) {
//           // Show error message
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(message),
//               backgroundColor: AppColors.error,
//             ),
//           );
//         },
//         passwordResetSent: () {
//           // Show success message and update UI
//           setState(() {
//             _isEmailSent = true;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(AppStrings.passwordResetSent),
//               backgroundColor: AppColors.success,
//             ),
//           );
//         },
//       );
//     });
//
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: AppColors.primaryGradient,
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: Insets.screenPadding,
//               child: Column(
//                 children: [
//                   SizedBox(height: Insets.verticalMd),
//
//                   // Header with back button
//                   _buildHeader(),
//
//                   SizedBox(height: Insets.verticalXxl),
//
//                   // Icon
//                   _buildIcon(),
//
//                   SizedBox(height: Insets.verticalXl),
//
//                   // Form container
//                   AuthFormContainer(
//                     child: _isEmailSent
//                         ? _buildSuccessContent()
//                         : _buildResetForm(),
//                   ),
//
//                   SizedBox(height: Insets.verticalMd),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       children: [
//         IconButton(
//           onPressed: _navigateBack,
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: AppColors.textOnPrimary,
//             size: Insets.iconMd,
//           ),
//         ),
//         Expanded(
//           child: Text(
//             AppStrings.resetPassword,
//             style: AppTypography.h5.copyWith(
//               color: AppColors.textOnPrimary,
//               fontWeight: FontWeight.w600,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         SizedBox(width: Insets.iconMd + 16), // Balance the back button
//       ],
//     );
//   }
//
//   Widget _buildIcon() {
//     return Container(
//       width: 80.w,
//       height: 80.w,
//       decoration: BoxDecoration(
//         color: AppColors.textOnPrimary.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(40.r),
//       ),
//       child: Icon(
//         _isEmailSent ? Icons.mark_email_read_outlined : Icons.lock_reset,
//         size: 40.w,
//         color: AppColors.textOnPrimary,
//       ),
//     );
//   }
//
//   Widget _buildResetForm() {
//     final isLoading = authState.maybeWhen(
//       loading: () => true,
//       orElse: () => false,
//     );
//
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Title
//           Text(
//             'Reset your password',
//             style: AppTypography.h5.copyWith(
//               fontWeight: FontWeight.w600,
//             ),
//             textAlign: TextAlign.center,
//           ),
//
//           SizedBox(height: Insets.sm),
//
//           // Subtitle
//           Text(
//             'Enter your email address and we\'ll send you a link to reset your password.',
//             style: AppTypography.bodyMedium.copyWith(
//               color: AppColors.textSecondaryLight,
//             ),
//             textAlign: TextAlign.center,
//           ),
//
//           SizedBox(height: Insets.verticalLg),
//
//           // Email field
//           AuthTextField(
//             controller: _emailController,
//             hintText: AppStrings.enterYourEmail,
//             keyboardType: TextInputType.emailAddress,
//             prefixIcon: Icons.email_outlined,
//             validator: Validators.validateEmail,
//             enabled: !isLoading,
//           ),
//
//           SizedBox(height: Insets.verticalLg),
//
//           // Send reset link button
//           AuthButton(
//             text: 'Send Reset Link',
//             onPressed: isLoading ? null : _handleResetPassword,
//             isLoading: isLoading,
//           ),
//
//           SizedBox(height: Insets.verticalMd),
//
//           // Back to login
//           TextButton(
//             onPressed: isLoading ? null : _navigateBack,
//             child: Text(
//               'Back to Login',
//               style: AppTypography.bodyMedium.copyWith(
//                 color: AppColors.primaryBlue,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSuccessContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Success icon
//         Container(
//           width: 60.w,
//           height: 60.w,
//           decoration: BoxDecoration(
//             color: AppColors.success.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(30.r),
//           ),
//           child: Icon(
//             Icons.check_circle_outline,
//             size: 30.w,
//             color: AppColors.success,
//           ),
//         ),
//
//         SizedBox(height: Insets.lg),
//
//         // Title
//         Text(
//           'Check your email',
//           style: AppTypography.h5.copyWith(
//             fontWeight: FontWeight.w600,
//           ),
//           textAlign: TextAlign.center,
//         ),
//
//         SizedBox(height: Insets.sm),
//
//         // Message
//         Text(
//           'We\'ve sent a password reset link to\n${_emailController.text}',
//           style: AppTypography.bodyMedium.copyWith(
//             color: AppColors.textSecondaryLight,
//           ),
//           textAlign: TextAlign.center,
//         ),
//
//         SizedBox(height: Insets.verticalLg),
//
//         // Resend button
//         AuthButton(
//           text: 'Resend Email',
//           onPressed: _handleResetPassword,
//           isSecondary: true,
//         ),
//
//         SizedBox(height: Insets.verticalMd),
//
//         // Back to login
//         TextButton(
//           onPressed: _navigateBack,
//           child: Text(
//             'Back to Login',
//             style: AppTypography.bodyMedium.copyWith(
//               color: AppColors.primaryBlue,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }