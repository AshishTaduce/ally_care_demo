import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? additionalInfo;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.dateOfBirth,
    required this.emailVerified,
    required this.createdAt,
    required this.updatedAt,
    this.additionalInfo,
  });

  // Factory constructor for creating UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      emailVerified: json['emailVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  // Factory constructor for creating UserModel from Firestore
  factory UserModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      email: data['email'] as String,
      displayName: data['displayName'] as String,
      photoURL: data['photoURL'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      dateOfBirth: data['dateOfBirth']?.toDate(),
      emailVerified: data['emailVerified'] as bool? ?? false,
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: data['updatedAt']?.toDate() ?? DateTime.now(),
      additionalInfo: data['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  // Factory constructor for creating UserModel from Firebase Auth User
  factory UserModel.fromFirebaseUser(
      dynamic firebaseUser, {
        DateTime? dateOfBirth,
        String? phoneNumber,
        Map<String, dynamic>? additionalInfo,
      }) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? 'User',
      photoURL: firebaseUser.photoURL,
      phoneNumber: phoneNumber ?? firebaseUser.phoneNumber,
      dateOfBirth: dateOfBirth,
      emailVerified: firebaseUser.emailVerified,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      additionalInfo: additionalInfo,
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'emailVerified': emailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'additionalInfo': additionalInfo,
    };
  }

  // Convert UserModel to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'emailVerified': emailVerified,
      'createdAt': createdAt,
      'updatedAt': DateTime.now(),
      'additionalInfo': additionalInfo,
    };
  }

  // Copy with method for updating user data
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    DateTime? dateOfBirth,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? additionalInfo,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  // Get initials for avatar
  String get initials {
    final names = displayName.trim().split(' ');
    if (names.length == 1) {
      return names[0].isNotEmpty ? names[0][0].toUpperCase() : 'U';
    }
    return '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
  }

  // Get first name
  String get firstName {
    final names = displayName.trim().split(' ');
    return names.isNotEmpty ? names[0] : '';
  }

  // Get last name
  String get lastName {
    final names = displayName.trim().split(' ');
    return names.length > 1 ? names.sublist(1).join(' ') : '';
  }

  // Check if profile is complete
  bool get isProfileComplete {
    return displayName.isNotEmpty &&
        email.isNotEmpty &&
        photoURL != null &&
        phoneNumber != null &&
        dateOfBirth != null;
  }

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoURL,
    phoneNumber,
    dateOfBirth,
    emailVerified,
    createdAt,
    updatedAt,
    additionalInfo,
  ];

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName, emailVerified: $emailVerified)';
  }
}