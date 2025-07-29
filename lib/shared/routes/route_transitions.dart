import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';

class AppPageTransition {
  // Fade transition
  static Page<void> fade({
    required Widget child,
    required GoRouterState settings,
    Duration? duration,
  }) {
    return CustomTransitionPage<void>(
      key: settings.pageKey,
      child: child,
      transitionDuration: duration ?? AppConstants.mediumAnimationDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // Slide from right transition
  static Page<void> slideFromRight({
    required Widget child,
    required GoRouterState settings,
    Duration? duration,
  }) {
    return CustomTransitionPage<void>(
      key: settings.pageKey,
      child: child,
      transitionDuration: duration ?? AppConstants.mediumAnimationDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Slide from left transition
  static Page<void> slideFromLeft({
    required Widget child,
    required GoRouterState settings,
    Duration? duration,
  }) {
    return CustomTransitionPage<void>(
      key: settings.pageKey,
      child: child,
      transitionDuration: duration ?? AppConstants.mediumAnimationDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Slide from bottom transition
  static Page<void> slideFromBottom({
    required Widget child,
    required GoRouterState settings,
    Duration? duration,
  }) {
    return CustomTransitionPage<void>(
      key: settings.pageKey,
      child: child,
      transitionDuration: duration ?? AppConstants.mediumAnimationDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Slide from top transition
  static Page<void> slideFromTop({
    required Widget child,
    required GoRouterState settings,
    Duration? duration,
  }) {
    return CustomTransitionPage<void>(
      key: settings.pageKey,
      child: child,
      transitionDuration: duration ?? AppConstants.mediumAnimationDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Scale transition
  static Page<void> scale({
    required Widget child,
    required GoRouterState settings,
    Duration? duration,
  }) {
    return CustomTransitionPage<void>(
      key: settings.pageKey,
      child: child,
      transitionDuration: duration ?? AppConstants.mediumAnimationDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return ScaleTransition(
          scale: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Rotation transition
  static Page<void> rotation({
    required Widget child,
    required GoRouterState settings,
    Duration? duration,
  }) {
    return CustomTransitionPage<void>(
      key: settings.pageKey,
      child: child,
      transitionDuration: duration ?? AppConstants.mediumAnimationDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return RotationTransition(
          turns: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Size transition
  static Page<void> size({
    required Widget child,
    required GoRouterState settings,
    Duration? duration,
  }) {
    return CustomTransitionPage<void>(
      key: settings.pageKey,
      child: child,
      transitionDuration: duration ?? AppConstants.mediumAnimationDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SizeTransition(
          sizeFactor: animation,
          child: child,
        );
      },
    );
  }

  // Combined slide and fade transition
  static Page<void> slideAndFade({
    required Widget child,
    required GoRouterState settings,
    Duration? duration,
    Offset? begin,
  }) {
    return CustomTransitionPage<void>(
      key: settings.pageKey,
      child: child,
      transitionDuration: duration ?? AppConstants.mediumAnimationDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideBegin = begin ?? const Offset(1.0, 0.0);
        const slideEnd = Offset.zero;
        const curve = Curves.easeInOut;

        var slideTween = Tween(begin: slideBegin, end: slideEnd).chain(
          CurveTween(curve: curve),
        );

        var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }

  // Hero transition (for image transitions)
  static Page<void> hero({
    required Widget child,
    required GoRouterState settings,
    required String heroTag,
    Duration? duration,
  }) {
    return CustomTransitionPage<void>(
      key: settings.pageKey,
      child: child,
      transitionDuration: duration ?? AppConstants.longAnimationDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // No transition (instant)
  static Page<void> none({
    required Widget child,
    required GoRouterState settings,
  }) {
    return MaterialPage<void>(
      key: settings.pageKey,
      child: child,
    );
  }
}