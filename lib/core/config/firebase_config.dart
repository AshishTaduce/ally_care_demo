import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

/// Firebase configuration for AllyCare Demo
///
/// This class provides a secure way to configure Firebase using environment variables
/// instead of hardcoded values in the codebase.
class FirebaseConfig {
  /// Private constructor to prevent instantiation
  FirebaseConfig._();

  /// Get Firebase options for the current platform
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  /// Android Firebase configuration
  static FirebaseOptions get android => FirebaseOptions(
    apiKey:
        dotenv.env['FIREBASE_API_KEY_ANDROID'] ??
        _throwMissingKey('FIREBASE_API_KEY_ANDROID'),
    appId:
        dotenv.env['FIREBASE_APP_ID_ANDROID'] ??
        _throwMissingKey('FIREBASE_APP_ID_ANDROID'),
    messagingSenderId:
        dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ??
        _throwMissingKey('FIREBASE_MESSAGING_SENDER_ID'),
    projectId:
        dotenv.env['FIREBASE_PROJECT_ID'] ??
        _throwMissingKey('FIREBASE_PROJECT_ID'),
    authDomain:
        dotenv.env['FIREBASE_AUTH_DOMAIN'] ??
        _throwMissingKey('FIREBASE_AUTH_DOMAIN'),
    storageBucket:
        dotenv.env['FIREBASE_STORAGE_BUCKET'] ??
        _throwMissingKey('FIREBASE_STORAGE_BUCKET'),
    measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'],
  );

  /// iOS Firebase configuration
  static FirebaseOptions get ios => FirebaseOptions(
    apiKey:
        dotenv.env['FIREBASE_API_KEY_IOS'] ??
        _throwMissingKey('FIREBASE_API_KEY_IOS'),
    appId:
        dotenv.env['FIREBASE_APP_ID_IOS'] ??
        _throwMissingKey('FIREBASE_APP_ID_IOS'),
    messagingSenderId:
        dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ??
        _throwMissingKey('FIREBASE_MESSAGING_SENDER_ID'),
    projectId:
        dotenv.env['FIREBASE_PROJECT_ID'] ??
        _throwMissingKey('FIREBASE_PROJECT_ID'),
    authDomain:
        dotenv.env['FIREBASE_AUTH_DOMAIN'] ??
        _throwMissingKey('FIREBASE_AUTH_DOMAIN'),
    storageBucket:
        dotenv.env['FIREBASE_STORAGE_BUCKET'] ??
        _throwMissingKey('FIREBASE_STORAGE_BUCKET'),
    iosBundleId: dotenv.env['IOS_BUNDLE_ID'] ?? 'com.example.ally_care_demo',
    measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'],
  );

  /// macOS Firebase configuration
  static FirebaseOptions get macos => FirebaseOptions(
    apiKey:
        dotenv.env['FIREBASE_API_KEY_IOS'] ??
        _throwMissingKey('FIREBASE_API_KEY_IOS'),
    appId:
        dotenv.env['FIREBASE_APP_ID_IOS'] ??
        _throwMissingKey('FIREBASE_APP_ID_IOS'),
    messagingSenderId:
        dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ??
        _throwMissingKey('FIREBASE_MESSAGING_SENDER_ID'),
    projectId:
        dotenv.env['FIREBASE_PROJECT_ID'] ??
        _throwMissingKey('FIREBASE_PROJECT_ID'),
    authDomain:
        dotenv.env['FIREBASE_AUTH_DOMAIN'] ??
        _throwMissingKey('FIREBASE_AUTH_DOMAIN'),
    storageBucket:
        dotenv.env['FIREBASE_STORAGE_BUCKET'] ??
        _throwMissingKey('FIREBASE_STORAGE_BUCKET'),
    iosBundleId: dotenv.env['IOS_BUNDLE_ID'] ?? 'com.example.ally_care_demo',
  );

  /// Web Firebase configuration (Windows/Linux)
  static FirebaseOptions get web => FirebaseOptions(
    apiKey:
        dotenv.env['FIREBASE_API_KEY_WEB'] ??
        _throwMissingKey('FIREBASE_API_KEY_WEB'),
    appId:
        dotenv.env['FIREBASE_APP_ID_WEB'] ??
        _throwMissingKey('FIREBASE_APP_ID_WEB'),
    messagingSenderId:
        dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ??
        _throwMissingKey('FIREBASE_MESSAGING_SENDER_ID'),
    projectId:
        dotenv.env['FIREBASE_PROJECT_ID'] ??
        _throwMissingKey('FIREBASE_PROJECT_ID'),
    authDomain:
        dotenv.env['FIREBASE_AUTH_DOMAIN'] ??
        _throwMissingKey('FIREBASE_AUTH_DOMAIN'),
    storageBucket:
        dotenv.env['FIREBASE_STORAGE_BUCKET'] ??
        _throwMissingKey('FIREBASE_STORAGE_BUCKET'),
    measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'],
  );

  /// Windows Firebase configuration
  static FirebaseOptions get windows => web;

  /// Linux Firebase configuration
  static FirebaseOptions get linux => web;

  /// Helper method to throw descriptive error for missing environment variables
  static String _throwMissingKey(String key) {
    throw Exception(
      'Missing required environment variable: $key\n'
      'Please ensure your .env file is properly configured.\n'
      'See docs/ENVIRONMENT_SETUP.md for detailed setup instructions.',
    );
  }

  /// Validate that all required environment variables are present
  static void validateConfiguration() {
    final requiredKeys = [
      'FIREBASE_PROJECT_ID',
      'FIREBASE_AUTH_DOMAIN',
      'FIREBASE_STORAGE_BUCKET',
      'FIREBASE_MESSAGING_SENDER_ID',
      'FIREBASE_API_KEY_ANDROID',
      'FIREBASE_API_KEY_IOS',
      'FIREBASE_API_KEY_WEB',
      'FIREBASE_APP_ID_ANDROID',
      'FIREBASE_APP_ID_IOS',
      'FIREBASE_APP_ID_WEB',
    ];

    final missingKeys = <String>[];
    for (final key in requiredKeys) {
      if (dotenv.env[key] == null || dotenv.env[key]!.isEmpty) {
        missingKeys.add(key);
      }
    }

    if (missingKeys.isNotEmpty) {
      throw Exception(
        'Missing required environment variables:\n'
        '${missingKeys.map((key) => '  - $key').join('\n')}\n\n'
        'Please check your .env file and ensure all required variables are set.\n'
        'See docs/ENVIRONMENT_SETUP.md for detailed setup instructions.',
      );
    }
  }

  /// Check if Firebase is configured for development/demo mode
  static bool get isDemoMode {
    final projectId = dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
    return projectId.contains('demo') ||
        projectId.contains('test') ||
        dotenv.env['APP_ENV'] == 'demo';
  }

  /// Get Firebase emulator configuration
  static Map<String, String> get emulatorConfig => {
    'host': dotenv.env['FIREBASE_EMULATOR_HOST'] ?? 'localhost',
    'authPort': dotenv.env['FIREBASE_AUTH_EMULATOR_PORT'] ?? '9099',
    'firestorePort': dotenv.env['FIRESTORE_EMULATOR_PORT'] ?? '8080',
    'storagePort': dotenv.env['FIREBASE_STORAGE_EMULATOR_PORT'] ?? '9199',
  };

  /// Check if Firebase emulator should be used
  static bool get useEmulator {
    return dotenv.env['USE_FIREBASE_EMULATOR']?.toLowerCase() == 'true';
  }
}
