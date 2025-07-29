# 🔧 Environment Setup Guide

This guide will help you set up the environment variables and configuration needed to run AllyCare locally.

## 📋 Table of Contents

- [Prerequisites](#-prerequisites)
- [Firebase Setup](#-firebase-setup)
- [Environment Configuration](#-environment-configuration)
- [Platform-Specific Setup](#-platform-specific-setup)
- [Verification](#-verification)
- [Troubleshooting](#-troubleshooting)

---

## 🚀 Prerequisites

Before setting up the environment, ensure you have:

- **Flutter SDK** 3.8.1 or higher
- **Firebase CLI** installed globally
- **Google Account** for Firebase access
- **Android Studio** or **Xcode** for platform-specific setup

### Install Firebase CLI

```bash
# Install via npm
npm install -g firebase-tools

# Or install via curl (macOS/Linux)
curl -sL https://firebase.tools | bash

# Verify installation
firebase --version
```

---

## 🔥 Firebase Setup

### Step 1: Create Firebase Project

1. **Go to Firebase Console**
   - Visit [Firebase Console](https://console.firebase.google.com/)
   - Click "Create a project" or "Add project"

2. **Configure Project**
   ```
   Project Name: AllyCare Demo (or your preferred name)
   Project ID: your-unique-project-id
   Analytics: Enable (recommended)
   ```

3. **Wait for Project Creation**
   - Firebase will set up your project
   - This may take a few minutes

### Step 2: Enable Required Services

#### Authentication
1. Go to **Authentication** > **Sign-in method**
2. Enable the following providers:
   - **Email/Password**: Enable
   - **Google**: Enable and configure

#### Firestore Database
1. Go to **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (for development)
4. Select your preferred location

#### Storage
1. Go to **Storage**
2. Click **Get started**
3. Use default security rules for now

#### Analytics (Optional)
1. Go to **Analytics**
2. Enable if not already enabled during project creation

### Step 3: Configure Firebase for Flutter

```bash
# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your Flutter project
flutterfire configure
```

Follow the prompts:
- Select your Firebase project
- Choose platforms (Android, iOS)
- The CLI will generate `firebase_options.dart`

---

## ⚙️ Environment Configuration

### Step 1: Copy Environment Template

```bash
# Copy the template file
cp .env.example .env
```

### Step 2: Get Firebase Configuration Values

#### From Firebase Console

1. **Go to Project Settings**
   - Click the gear icon ⚙️ in Firebase Console
   - Select "Project settings"

2. **Get Project Configuration**
   ```
   Project ID: your-project-id
   Web API Key: Found in "Web API Key" section
   ```

3. **Get App-Specific Configuration**
   - Scroll down to "Your apps" section
   - Click on your Android/iOS app
   - Copy the configuration values

#### From Generated Files

**Android Configuration** (`android/app/google-services.json`):
```json
{
  "project_info": {
    "project_id": "your-project-id",
    "firebase_url": "https://your-project-id-default-rtdb.firebaseio.com",
    "project_number": "123456789012",
    "storage_bucket": "your-project-id.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:123456789012:android:abcdef123456",
        "android_client_info": {
          "package_name": "com.example.ally_care_demo"
        }
      },
      "api_key": [
        {
          "current_key": "AIzaSyYourAndroidAPIKey"
        }
      ]
    }
  ]
}
```

**iOS Configuration** (`ios/Runner/GoogleService-Info.plist`):
```xml
<key>API_KEY</key>
<string>AIzaSyYourIOSAPIKey</string>
<key>GCM_SENDER_ID</key>
<string>123456789012</string>
<key>GOOGLE_APP_ID</key>
<string>1:123456789012:ios:abcdef123456</string>
<key>PROJECT_ID</key>
<string>your-project-id</string>
<key>STORAGE_BUCKET</key>
<string>your-project-id.appspot.com</string>
```

### Step 3: Fill Environment Variables

Edit your `.env` file with the values from Firebase:

```bash
# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_AUTH_DOMAIN=your-project-id.firebaseapp.com
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com
FIREBASE_MESSAGING_SENDER_ID=123456789012

# Firebase API Keys
FIREBASE_API_KEY_ANDROID=AIzaSyYourAndroidAPIKey
FIREBASE_API_KEY_IOS=AIzaSyYourIOSAPIKey
FIREBASE_API_KEY_WEB=AIzaSyYourWebAPIKey

# Firebase App IDs
FIREBASE_APP_ID_ANDROID=1:123456789012:android:abcdef123456
FIREBASE_APP_ID_IOS=1:123456789012:ios:abcdef123456

# Google Sign-In Configuration
GOOGLE_SIGN_IN_CLIENT_ID_ANDROID=123456789012-abcdef.apps.googleusercontent.com
GOOGLE_SIGN_IN_CLIENT_ID_IOS=123456789012-ghijkl.apps.googleusercontent.com
GOOGLE_SIGN_IN_CLIENT_ID_WEB=123456789012-mnopqr.apps.googleusercontent.com

# App Configuration
APP_ENV=development
APP_DEBUG=true
APP_VERSION=1.0.0
```

---

## 📱 Platform-Specific Setup

### Android Setup

#### 1. Update Package Name (Optional)

If you want to change the package name from `com.example.ally_care_demo`:

1. **Update `android/app/build.gradle.kts`**:
   ```kotlin
   android {
       namespace = "com.yourcompany.allycare"
       defaultConfig {
           applicationId = "com.yourcompany.allycare"
           // ... other config
       }
   }
   ```

2. **Update Firebase Configuration**:
   - Go to Firebase Console > Project Settings
   - Add new Android app with your package name
   - Download new `google-services.json`
   - Replace the file in `android/app/`

#### 2. Configure Google Sign-In

1. **Get SHA-1 Fingerprint**:
   ```bash
   # For debug keystore
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   
   # For release keystore (when you have one)
   keytool -list -v -keystore /path/to/your/keystore.jks -alias your-alias
   ```

2. **Add SHA-1 to Firebase**:
   - Go to Firebase Console > Project Settings
   - Select your Android app
   - Add the SHA-1 fingerprint

#### 3. Update Gradle Files

Ensure `android/app/build.gradle.kts` has:
```kotlin
plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Add this line
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}
```

### iOS Setup

#### 1. Update Bundle Identifier (Optional)

If you want to change the bundle identifier:

1. **Open `ios/Runner.xcworkspace` in Xcode**
2. **Select Runner project** > **Runner target**
3. **Update Bundle Identifier** in General tab
4. **Update Firebase Configuration** with new bundle ID

#### 2. Configure Google Sign-In

1. **Add URL Scheme**:
   - Open `ios/Runner/Info.plist`
   - Add the following (replace with your REVERSED_CLIENT_ID):
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleURLName</key>
           <string>REVERSED_CLIENT_ID</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>com.googleusercontent.apps.123456789012-abcdef</string>
           </array>
       </dict>
   </array>
   ```

2. **Find REVERSED_CLIENT_ID**:
   - Look in `ios/Runner/GoogleService-Info.plist`
   - Find the `REVERSED_CLIENT_ID` value

---

## ✅ Verification

### Step 1: Generate Code

```bash
# Generate necessary code files
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Step 2: Run Tests

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/features/auth/auth_test.dart
```

### Step 3: Start the App

```bash
# Run on connected device/emulator
flutter run

# Run with specific flavor
flutter run --flavor development
```

### Step 4: Test Firebase Connection

1. **Authentication Test**:
   - Try to create a new account
   - Try to sign in with Google
   - Check Firebase Console > Authentication > Users

2. **Firestore Test**:
   - Complete user profile setup
   - Check Firebase Console > Firestore Database

3. **Storage Test**:
   - Upload a profile image
   - Check Firebase Console > Storage

---

## 🔧 Troubleshooting

### Common Issues

#### 1. Firebase Configuration Not Found

**Error**: `FirebaseOptions cannot be null when creating the default app.`

**Solution**:
```bash
# Re-run FlutterFire configuration
flutterfire configure

# Ensure firebase_options.dart is generated
ls lib/firebase_options.dart
```

#### 2. Google Sign-In Not Working

**Error**: `PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 10: , null, null)`

**Solutions**:
- **Android**: Check SHA-1 fingerprint in Firebase Console
- **iOS**: Verify URL scheme in Info.plist
- **Both**: Ensure correct client IDs in environment variables

#### 3. Firestore Permission Denied

**Error**: `FirebaseException: [cloud_firestore/permission-denied]`

**Solution**:
```javascript
// Update Firestore rules (temporary for development)
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

#### 4. Build Failures

**Android Build Issues**:
```bash
# Clean and rebuild
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter run
```

**iOS Build Issues**:
```bash
# Clean and rebuild
flutter clean
flutter pub get
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
flutter run
```

### Environment Variable Issues

#### 1. Variables Not Loading

**Check**:
- `.env` file exists in project root
- Variables are properly formatted (no spaces around `=`)
- `flutter_dotenv` is properly configured

#### 2. Firebase Options Not Found

**Verify**:
```dart
// Check if firebase_options.dart exists
import 'firebase_options.dart';

// Verify Firebase initialization in main.dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Getting Help

If you're still having issues:

1. **Check the logs**:
   ```bash
   flutter logs
   ```

2. **Enable verbose logging**:
   ```bash
   flutter run -v
   ```

3. **Check Firebase Console**:
   - Look for error messages in Firebase Console
   - Check usage quotas and limits

4. **Create an issue**:
   - Include error messages
   - Provide environment details
   - Share relevant configuration (without sensitive data)

---

## 🔒 Security Best Practices

### Environment Variables

1. **Never commit `.env` files**:
   ```bash
   # Ensure .env is in .gitignore
   echo ".env" >> .gitignore
   ```

2. **Use different environments**:
   ```bash
   # Development
   .env.development

   # Staging
   .env.staging

   # Production
   .env.production
   ```

3. **Rotate API keys regularly**:
   - Generate new Firebase API keys periodically
   - Update environment variables
   - Revoke old keys

### Firebase Security

1. **Configure Firestore Rules**:
   ```javascript
   // Production-ready rules
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       match /appointments/{appointmentId} {
         allow read, write: if request.auth != null && 
           (request.auth.uid == resource.data.patientId || 
            request.auth.uid == resource.data.providerId);
       }
     }
   }
   ```

2. **Configure Storage Rules**:
   ```javascript
   // Secure storage rules
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /profile_images/{userId}/{allPaths=**} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

3. **Enable App Check** (for production):
   - Go to Firebase Console > App Check
   - Enable for your apps
   - Configure attestation providers

---

## 📚 Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Flutter Environment Variables](https://pub.dev/packages/flutter_dotenv)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)

---

**Need help?** Create an issue on GitHub or contact [support@allycare-demo.com](mailto:support@allycare-demo.com).