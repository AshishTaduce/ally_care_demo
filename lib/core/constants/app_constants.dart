class AppConstants {
  static const String appName = 'AllyCare';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String assessmentsCollection = 'assessments';
  static const String appointmentsCollection = 'appointments';
  static const String challengesCollection = 'challenges';
  static const String workoutRoutinesCollection = 'workout_routines';

  // Storage
  static const String profileImagesFolder = 'profile_images';
  static const String assessmentImagesFolder = 'assessment_images';

  // SharedPreferences Keys
  static const String favoritesKey = 'favorites';
  static const String themeKey = 'theme';
  static const String languageKey = 'language';
  static const String isFirstTimeKey = 'is_first_time';

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
  static const Duration splashDuration = Duration(milliseconds: 2000);

  // API Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Image Constraints
  static const int maxImageSizeInMB = 5;
  static const int imageQuality = 85;
  static const double maxImageWidth = 1024;
  static const double maxImageHeight = 1024;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int maxNameLength = 50;
  static const int minNameLength = 2;

  // UI Constants
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double buttonHeight = 48.0;
  static const double appBarHeight = 56.0;

  // Google Sign In
  static const List<String> googleSignInScopes = [
    'email',
    'profile',
  ];
}