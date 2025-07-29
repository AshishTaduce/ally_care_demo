class RouteNames {
  // Auth routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main app routes
  static const String home = '/home';

  // Assessment routes
  static const String assessments = 'assessments';
  static const String assessmentDetail = '/assessmentDetail';
  static const String challengesWorkout = 'challenges-workout';

  // Appointment routes
  static const String appointments = 'appointments';
  static const String appointmentDetail = '/appointmentDetail';
  static const String appointmentBooking = 'appointment-booking';

  // Profile routes
  static const String profile = 'profile';
  static const String editProfile = 'edit-profile';

  // Settings routes
  static const String settings = 'settings';
  static const String themeSettings = 'theme-settings';
  static const String languageSettings = 'language-settings';

  // T&C routes
  static const String termsAndConditions = 'terms-and-conditions';
  static const String privacyPolicy = 'privacy-policy';
  static const String aboutUs = 'about-us';
  static const String contactUs = 'contact-us';

  // Utility methods
  static String getAssessmentDetailPath(String id) => '/home/assessments/detail/$id';
  static String getAppointmentBookingPath(String id) => '/home/appointments/booking/$id';
  static String getAppointmentDetailPath(String id) => '/home/appointments/detail/$id';

  // Full paths for navigation
  static const String fullAssessments = '/home/assessments';
  static const String fullChallengesWorkout = '/home/assessments/challenges';
  static const String fullAppointments = '/home/appointments';
  static const String fullAppointmentDetail = '/home/appointments/detail';
  static const String fullProfile = '/home/profile';
  static const String fullEditProfile = '/home/profile/edit';
  static const String fullSettings = '/home/settings';
  static const String fullThemeSettings = '/home/settings/theme';
  static const String fullLanguageSettings = '/home/settings/language';
  static const String fullTermsAndConditions = '/home/terms-and-conditions';
  static const String fullPrivacyPolicy = '/home/privacy-policy';
  static const String fullAboutUs = '/home/about-us';
  static const String fullContactUs = '/home/contact-us';
}