import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/theme/insets.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/models/language_model.dart';
import '../../../../shared/routes/route_names.dart';
import '../../../../shared/widgets/language_selection_widget.dart';
import '../providers/auth_provider.dart';
import '../widgets/animated_waves.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(authNotifierProvider.notifier)
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  // For future references
  // void _handleGoogleSignIn() {
  //   ref.read(authNotifierProvider.notifier).signInWithGoogle();
  // }
  //
  // void _navigateToRegister() {
  //   context.push(RouteNames.register);
  // }
  //
  // void _navigateToForgotPassword() {
  //   context.push(RouteNames.forgotPassword);
  // }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Listen to auth state changes
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      next.when(
        initial: () {},
        loading: () {},
        authenticated: (user) {
          // Navigate to home on successful authentication
          context.go(RouteNames.home);
        },
        unauthenticated: () {},
        error: (message) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: AppColors.error),
          );
        },
        passwordResetSent: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(elevation: 0, actions: [_buildLanguageSelector()]),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Insets.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: Insets.verticalXxl * 2),
                    // Logo
                    Center(child: _buildLogo()),
                    SizedBox(height: Insets.verticalMd),
                    Text(
                      'Login or create your account',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Color(0xFF727A87),
                      ),
                    ),

                    _buildLoginForm(),
                  ],
                ),
              ),
            ),
            // Animated waves at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBottomWaves(
                height: 200,
                gradientColors: [
                  Color(0xFF4A90E2),
                  Color(0xFF7BB3F0),
                  Color(0xFF5BA3F5),
                ],
                animationSpeed: 1,
                waveCount: 6,
                minWaveHeight: MediaQuery.of(context).size.height * .4,
              ),
            ),
            // Support button
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.support_agent, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Support',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton(onPressed: () {}, child: _buildSupportButton(),),
    );
  }

  Widget _buildLanguageSelector() {
    return LanguageSelectorWidget(
      currentLanguage: AppLanguages.defaultLanguage,
      onLanguageChanged: (language) {
        // Handle language change - you'll implement this later
        print('Language changed to: ${language.name}');
      },
    );
  }

  Widget _buildLogo() {
    return Hero(
      tag: 'logo',
      child: SvgPicture.asset(
        'assets/images/logo/company_logo.svg',
        width: MediaQuery.of(context).size.width * 0.4,
        semanticsLabel: 'Dart Logo',
      ),
    );
  }

  Widget _buildLoginForm() {
    final authState = ref.watch(authNotifierProvider);

    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Insets.verticalXl),

          // Email field
          AuthTextField(
            controller: _emailController,
            hintText: AppStrings.enterYourEmail,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_rounded,
            validator: Validators.validateEmail,
            enabled: !isLoading,
          ),

          SizedBox(height: Insets.verticalMd),

          // // Password field
          AuthTextField(
            controller: _passwordController,
            hintText: AppStrings.enterYourPassword,
            obscureText: _obscurePassword,
            prefixIcon: Icons.password_rounded,
            suffixIcon: _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onSuffixIconTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            validator: Validators.validatePassword,
            enabled: !isLoading,
          ),

          SizedBox(height: Insets.verticalLg),

          // Continue button
          Center(
            child: AuthButton(
              text: AppStrings.continueText,
              onPressed: isLoading ? null : _handleLogin,
              isLoading: isLoading,
            ),
          ),

          // SizedBox(height: Insets.verticalMd),
          //
          // // Forgot password
          // Align(
          //   alignment: Alignment.center,
          //   child: TextButton(
          //     onPressed: isLoading ? null : _navigateToForgotPassword,
          //     child: Text(
          //       AppStrings.forgotPassword,
          //       style: AppTypography.bodyMedium.copyWith(
          //         color: AppColors.primaryBlue,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
          // ),
          //
          // SizedBox(height: Insets.verticalLg),
          //
          // // Divider
          // Row(
          //   children: [
          //     Expanded(
          //       child: Divider(
          //         color: AppColors.dividerLight,
          //         thickness: 1,
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.symmetric(horizontal: Insets.md),
          //       child: Text(
          //         AppStrings.orContinueWith,
          //         style: AppTypography.bodySmall.copyWith(
          //           color: AppColors.textSecondaryLight,
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: Divider(
          //         color: AppColors.dividerLight,
          //         thickness: 1,
          //       ),
          //     ),
          //   ],
          // ),
          //
          // SizedBox(height: Insets.verticalLg),
          //
          // // Google sign in button
          // SocialLoginButton(
          //   onPressed: isLoading ? null : _handleGoogleSignIn,
          //   isLoading: isLoading,
          // ),
          //
          // SizedBox(height: Insets.verticalLg),
          //
          // // Register link
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       AppStrings.dontHaveAccount,
          //       style: AppTypography.bodyMedium.copyWith(
          //         color: AppColors.textSecondaryLight,
          //       ),
          //     ),
          //     TextButton(
          //       onPressed: isLoading ? null : _navigateToRegister,
          //       child: Text(
          //         AppStrings.register,
          //         style: AppTypography.bodyMedium.copyWith(
          //           color: AppColors.primaryBlue,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

}
