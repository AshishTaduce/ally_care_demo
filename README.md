# WIP

# 🏥 AllyCare Demo

A modern Flutter healthcare demo app featuring appointment scheduling, health assessments, wellness tracking, and secure patient-provider communication. Built with Firebase, Riverpod, and Material Design 3.

---

## 🚀 Features

- Secure authentication (Email/Password, Google Sign-In)
- Appointment scheduling and management
- Health assessments and tracking
- Wellness and fitness routines
- Profile management
- Material Design 3 UI with light/dark themes
- Offline support with Hive
- State management with Riverpod

---

## 🗂️ Folder Structure

```
ally_care_demo/
├── lib/
│   ├── main.dart
│   ├── src/
│   │   ├── features/         # Feature modules (auth, appointments, etc.)
│   │   ├── core/             # Core utilities, themes, constants
│   │   ├── models/           # Data models
│   │   ├── services/         # API, Firebase, local storage services
│   │   ├── providers/        # Riverpod providers
│   │   └── widgets/          # Shared/reusable widgets
├── assets/
│   ├── images/
│   ├── images/logo/
│   ├── images/icons/
│   ├── images/illustrations/
│   ├── animations/
│   └── .env
├── test/                     # Unit and widget tests
├── pubspec.yaml
└── README.md
```

---

## 🏗️ Architecture

- **Feature-first structure:** Each feature (e.g., auth, appointments) is modularized for scalability.
- **State management:** Uses [Riverpod](https://riverpod.dev/) for robust, testable state management.
- **Data layer:** Integrates Firebase (Auth, Firestore, Storage) and Hive for local persistence.
- **Routing:** Uses [go_router](https://pub.dev/packages/go_router) for declarative navigation.
- **Code generation:** Uses build_runner for Riverpod, JSON serialization, and Hive adapters.

---

## 📦 Packages Used

- **State Management:** `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`
- **Firebase:** `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`
- **Navigation:** `go_router`
- **Local Storage:** `hive`, `hive_flutter`, `shared_preferences`
- **Networking:** `dio`, `connectivity_plus`
- **UI/UX:** `cupertino_icons`, `google_fonts`, `flutter_screenutil`, `shimmer`, `lottie`, `animations`, `flutter_svg`, `table_calendar`, `pull_to_refresh`, `sliver_snap`, `animated_icon`
- **Utilities:** `dartz`, `equatable`, `uuid`, `intl`
- **Image Handling:** `image_picker`, `cached_network_image`
- **Localization:** `flutter_localizations`
- **Code Generation:** `build_runner`, `json_serializable`, `json_annotation`, `hive_generator`

---

## 🛠️ Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/ally_care_demo.git
cd ally_care_demo
```

### 2. Configure Environment

Copy the example environment file and fill in your Firebase credentials:

```bash
cp .env.example .env
# Edit .env with your Firebase and app config
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Generate code (build_runner)

Run this whenever you change models, providers, or adapters:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Run the app

```bash
flutter run
```

---

## 🔥 Firebase Setup

- Create a Firebase project
- Enable Authentication, Firestore, and Storage
- Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- Place them in the appropriate platform folders

---

## 🧪 Running Tests

```bash
flutter test
```

---

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) and open issues or pull requests.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

**Disclaimer:**  
This software is for demonstration and educational purposes only. Not for use in actual healthcare settings or for making medical