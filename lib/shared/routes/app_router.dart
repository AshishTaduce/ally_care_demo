import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/assessment/presentation/screens/assessments_screen.dart';
import '../../features/assessment/presentation/screens/assessment_detail_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screen/home_screen.dart';
import 'route_names.dart';
import 'route_transitions.dart';
import '../../features/assessment/data/assessment_model.dart';
import '../../features/appointment/presentation/screens/all_appointments_screen.dart';
import '../../features/appointment/presentation/screens/appointment_detail_screen.dart';
import '../../features/appointment/data/appointment_model.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/terms_and_conditions_screen.dart';
import '../../features/settings/presentation/screens/privacy_policy_screen.dart';
import '../../features/settings/presentation/screens/about_us_screen.dart';
import '../../features/settings/presentation/screens/contact_us_screen.dart';

// GoRouter provider
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);

      return authState.when(
        data: (user) {
          final isLoggedIn = user != null;
          final isAuthPage = [
            RouteNames.splash,
            RouteNames.login,
            RouteNames.register,
            RouteNames.forgotPassword,
          ].contains(state.matchedLocation);

          // If user is logged in and on splash, go directly to home
          if (isLoggedIn && state.matchedLocation == RouteNames.splash) {
            return RouteNames.home;
          }

          // If user is logged in and trying to access other auth pages, redirect to home
          if (isLoggedIn && isAuthPage && state.matchedLocation != RouteNames.splash) {
            return RouteNames.home;
          }

          // If user is not logged in and trying to access protected pages, redirect to login
          if (!isLoggedIn && !isAuthPage) {
            return RouteNames.login;
          }

          return null; // No redirect needed
        },
        loading: () => null, // Stay on current page while loading
        error: (error, stack) {
          // On error, redirect to login unless already on auth pages
          final isAuthPage = [
            RouteNames.splash,
            RouteNames.login,
            RouteNames.register,
            RouteNames.forgotPassword,
          ].contains(state.matchedLocation);

          return isAuthPage ? null : RouteNames.login;
        },
      );
    },
    routes: [
      // Splash route
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        pageBuilder: (context, state) => AppPageTransition.fade(
          child: const SplashScreen(),
          settings: state,
        ),
      ),

      // Authentication routes
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        pageBuilder: (context, state) => AppPageTransition.slideFromRight(
          child: const LoginScreen(),
          settings: state,
        ),
      ),

      // GoRoute(
      //   path: RouteNames.register,
      //   name: RouteNames.register,
      //   pageBuilder: (context, state) => AppPageTransition.slideFromRight(
      //     child: const RegisterScreen(),
      //     settings: state,
      //   ),
      // ),
      //
      // GoRoute(
      //   path: RouteNames.forgotPassword,
      //   name: RouteNames.forgotPassword,
      //   pageBuilder: (context, state) => AppPageTransition.slideFromBottom(
      //     child: const ForgotPasswordScreen(),
      //     settings: state,
      //   ),
      // ),

      // Main app routes (will be added later)
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        pageBuilder: (context, state) => AppPageTransition.fade(
          child: HomeScreen(),
          settings: state,
        ),
        routes: [
          // Assessment routes
          GoRoute(
            path: 'assessments',
            name: RouteNames.assessments,
            pageBuilder: (context, state) => AppPageTransition.slideFromRight(
              child: const AssessmentsScreen(),
              settings: state,
            ),
            routes: [
              GoRoute(
                path: 'detail/:id',
                name: RouteNames.assessmentDetail,
                pageBuilder: (context, state) {
                  final assessment = state.extra as AssessmentModel?;
                  final id = state.pathParameters['id']!;
                  return AppPageTransition.slideAndFade(
                    child: assessment != null
                        ? AssessmentDetailScreen(assessment: assessment)
                        : Scaffold(body: Center(child: Text('Assessment not found'))),
                    settings: state,
                    begin: const Offset(0.0, 0.2), // subtle slide up and fade
                  );
                },
              ),
              GoRoute(
                path: 'challenges',
                name: RouteNames.challengesWorkout,
                pageBuilder: (context, state) => AppPageTransition.slideFromRight(
                  child: const Scaffold(
                    body: Center(
                      child: Text('Challenges & Workout - Coming Soon'),
                    ),
                  ),
                  settings: state,
                ),
              ),
            ],
          ),

          // Appointment routes
          GoRoute(
            path: 'appointments',
            name: RouteNames.appointments,
            pageBuilder: (context, state) => AppPageTransition.slideFromRight(
              child: const AllAppointmentsScreen(),
              settings: state,
            ),
            routes: [
              GoRoute(
                path: 'detail/:id',
                name: RouteNames.appointmentDetail,
                pageBuilder: (context, state) {
                  final appointment = state.extra as AppointmentModel?;
                  // final id = state.pathParameters['id']!;
                  return AppPageTransition.slideAndFade(
                    child: appointment != null
                        ? AppointmentDetailScreen(appointment: appointment)
                        : Scaffold(body: Center(child: Text('Appointment not found'))),
                    settings: state,
                    begin: const Offset(0.0, 0.2),
                  );
                },
              ),
            ],
          ),

          // Profile routes
          GoRoute(
            path: 'profile',
            name: RouteNames.profile,
            pageBuilder: (context, state) => AppPageTransition.slideFromRight(
              child: const ProfileScreen(),
              settings: state,
            ),
          ),

          // Settings routes
          GoRoute(
            path: 'settings',
            name: RouteNames.settings,
            pageBuilder: (context, state) => AppPageTransition.slideFromRight(
              child: const SettingsScreen(),
              settings: state,
            ),
          ),

          // T&C routes
          GoRoute(
            path: 'terms-and-conditions',
            name: RouteNames.termsAndConditions,
            pageBuilder: (context, state) => AppPageTransition.slideFromRight(
              child: const TermsAndConditionsScreen(),
              settings: state,
            ),
          ),
          GoRoute(
            path: 'privacy-policy',
            name: RouteNames.privacyPolicy,
            pageBuilder: (context, state) => AppPageTransition.slideFromRight(
              child: const PrivacyPolicyScreen(),
              settings: state,
            ),
          ),
          GoRoute(
            path: 'about-us',
            name: RouteNames.aboutUs,
            pageBuilder: (context, state) => AppPageTransition.slideFromRight(
              child: const AboutUsScreen(),
              settings: state,
            ),
          ),
          GoRoute(
            path: 'contact-us',
            name: RouteNames.contactUs,
            pageBuilder: (context, state) => AppPageTransition.slideFromRight(
              child: const ContactUsScreen(),
              settings: state,
            ),
          ),
        ],
      ),
    ],

    // Error page
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'The page you are looking for does not exist.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(RouteNames.home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
});