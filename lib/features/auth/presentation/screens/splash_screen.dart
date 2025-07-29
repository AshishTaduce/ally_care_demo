import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/routes/route_names.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: AppConstants.longAnimationDuration,
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    ));

    _startSplashSequence();
  }

  void _startSplashSequence() async {
    // Start logo animation immediately
    _logoController.forward();

    // Wait for splash duration then check auth state and navigate
    await Future.delayed(AppConstants.splashDuration);
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    final authState = ref.read(authStateProvider);

    authState.when(
      data: (user) {
        if (user != null) {
          // User is logged in, navigate to home
          context.go(RouteNames.home);
        } else {
          // User is not logged in, navigate to login
          context.go(RouteNames.login);
        }
      },
      loading: () {
        // Still loading, wait a bit more
        Future.delayed(const Duration(milliseconds: 500), () {
          _checkAuthAndNavigate();
        });
      },
      error: (error, stack) {
        // Error occurred, navigate to login
        context.go(RouteNames.login);
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

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _logoController,
            builder: (context, child) {
              return Transform.scale(
                scale: _logoScaleAnimation.value,
                child: Opacity(
                  opacity: _logoOpacityAnimation.value,
                  child: _buildLogo(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}