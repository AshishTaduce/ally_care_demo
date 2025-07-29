// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/constants/app_strings.dart';
// import '../../../../core/theme/typography.dart';
// import '../../../../core/theme/insets.dart';
// import '../../../../core/utils/validators.dart';
// import '../../../../shared/routes/route_names.dart';
// import '../providers/auth_provider.dart';
// import '../widgets/auth_text_field.dart';
// import '../widgets/auth_button.dart';
// import '../widgets/social_login_button.dart';
// import '../widgets/auth_form_container.dart';
// import '../widgets/profile_image_picker.dart';
//
// class RegisterScreen extends ConsumerStatefulWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends ConsumerState<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   File? _profileImage;
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   void _handleRegister() {
//     if (_formKey.currentState?.validate() ?? false) {
//       ref.read(authNotifierProvider.notifier).registerWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text,
//         displayName: _nameController.text.trim(),
//         profileImage: _profileImage,
//       );
//     }
//   }
//
//   void _handleGoogleSignIn() {
//     ref.read(authNotifierProvider.notifier).signInWithGoogle();
//   }
//
//   void _navigateToLogin() {
//     context.pop();
//   }
//
//   void _onImageSelected(File? image) {
//     setState(() {
//       _profileImage = image;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authNotifierProvider);
//
//     // Listen to auth state changes
//     ref.listen<AuthState>(authNotifierProvider, (previous, next) {
//       next.when(
//         initial: () {},
//         loading: () {},
//         authenticated: (user) {
//           // Navigate to home on successful registration
//           context.go(RouteNames.home);
//         },
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
//         passwordResetSent: () {},
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
//                   // Back button and title
//                   _buildHeader(),
//
//                   SizedBox(height: Insets.verticalXl),
//
//                   // Register form container
//                   AuthFormContainer(
//                     child: _buildRegisterForm(),
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
//           onPressed: () => context.pop(),
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: AppColors.textOnPrimary,
//             size: Insets.iconMd,
//           ),
//         ),
//         Expanded(
//           child: Text(
//             AppStrings.createAccount,
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
//   Widget _buildRegisterForm() {
//     final authState = ref.watch(authNotifierProvider);
//
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
//           // Profile image picker
//           ProfileImagePicker(
//             onImageSelected: _onImageSelected,
//             selectedImage: _profileImage,
//           ),
//
//           SizedBox(height: Insets.verticalLg),
//
//           // Full name field
//           AuthTextField(
//             controller: _nameController,
//             hintText: AppStrings.enterYourName,
//             prefixIcon: Icons.person_outline,
//             textCapitalization: TextCapitalization.words,
//             validator: Validators.validateName,
//             enabled: !isLoading,
//           ),
//
//           SizedBox(height: Insets.verticalMd),
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
//           SizedBox(height: Insets.verticalMd),
//
//           // Password field
//           AuthTextField(
//             controller: _passwordController,
//             hintText: AppStrings.enterYourPassword,
//             obscureText: _obscurePassword,
//             prefixIcon: Icons.lock_outline,
//             suffixIcon: _obscurePassword
//                 ? Icons.visibility_off_outlined
//                 : Icons.visibility_outlined,
//             onSuffixIconTap: () {
//               setState(() {
//                 _obscurePassword = !_obscurePassword;
//               });
//             },
//             validator: Validators.validatePassword,
//             enabled: !isLoading,
//           ),
//
//           SizedBox(height: Insets.verticalMd),
//
//           // Confirm password field
//           AuthTextField(
//             controller: _confirmPasswordController,
//             hintText: AppStrings.confirmPassword,
//             obscureText: _obscureConfirmPassword,
//             prefixIcon: Icons.lock_outline,
//             suffixIcon: _obscureConfirmPassword
//                 ? Icons.visibility_off_outlined
//                 : Icons.visibility_outlined,
//             onSuffixIconTap: () {
//               setState(() {
//                 _obscureConfirmPassword = !_obscureConfirmPassword;
//               });
//             },
//             validator: (value) => Validators.validateConfirmPassword(
//               value,
//               _passwordController.text,
//             ),
//             enabled: !isLoading,
//           ),
//
//           SizedBox(height: Insets.verticalXl),
//
//           // Create account button
//           AuthButton(
//             text: AppStrings.createAccount,
//             onPressed: isLoading ? null : _handleRegister,
//             isLoading: isLoading,
//           ),
//
//           SizedBox(height: Insets.verticalLg),
//
//           // Divider
//           Row(
//             children: [
//               Expanded(
//                 child: Divider(
//                   color: AppColors.dividerLight,
//                   thickness: 1,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: Insets.md),
//                 child: Text(
//                   AppStrings.orContinueWith,
//                   style: AppTypography.bodySmall.copyWith(
//                     color: AppColors.textSecondaryLight,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Divider(
//                   color: AppColors.dividerLight,
//                   thickness: 1,
//                 ),
//               ),
//             ],
//           ),
//
//           SizedBox(height: Insets.verticalLg),
//
//           // Google sign in button
//           SocialLoginButton(
//             onPressed: isLoading ? null : _handleGoogleSignIn,
//             isLoading: isLoading,
//           ),
//
//           SizedBox(height: Insets.verticalLg),
//
//           // Login link
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 AppStrings.alreadyHaveAccount,
//                 style: AppTypography.bodyMedium.copyWith(
//                   color: AppColors.textSecondaryLight,
//                 ),
//               ),
//               TextButton(
//                 onPressed: isLoading ? null : _navigateToLogin,
//                 child: Text(
//                   AppStrings.login,
//                   style: AppTypography.bodyMedium.copyWith(
//                     color: AppColors.primaryBlue,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }