import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dartz/dartz.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failures.dart';
import 'user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final GoogleSignIn _googleSignIn;

  AuthService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: AppConstants.googleSignInScopes);

  // Get current user stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Register with email and password
  Future<Either<Failure, UserModel>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    File? profileImage,
  }) async {
    try {
      // Create user with email and password
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return Left(AuthFailure('Failed to create user'));
      }

      // Update display name
      await credential.user!.updateDisplayName(displayName);

      String? photoURL;

      // Upload profile image if provided
      if (profileImage != null) {
        photoURL = await _uploadProfileImage(credential.user!.uid, profileImage);
        await credential.user!.updatePhotoURL(photoURL);
      }

      // Create user models
      final userModel = UserModel.fromFirebaseUser(
        credential.user!,
      );

      // Save user data to Firestore
      await _saveUserToFirestore(userModel);

      // Send email verification
      await credential.user!.sendEmailVerification();

      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getAuthErrorMessage(e.code)));
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Firestore error occurred'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Sign in with email and password
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return Left(AuthFailure('Failed to sign in'));
      }

      // Get user data from Firestore
      final userModel = await _getUserFromFirestore(credential.user!.uid);

      if (userModel != null) {
        return Right(userModel);
      } else {
        // If user data doesn't exist in Firestore, create it
        final newUserModel = UserModel.fromFirebaseUser(credential.user!);
        await _saveUserToFirestore(newUserModel);
        return Right(newUserModel);
      }
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getAuthErrorMessage(e.code)));
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Firestore error occurred'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Sign in with Google
  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return Left(AuthFailure('Google sign-in was cancelled'));
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        return Left(AuthFailure('Failed to sign in with Google'));
      }

      // Check if user exists in Firestore
      UserModel? existingUser = await _getUserFromFirestore(userCredential.user!.uid);

      if (existingUser != null) {
        // Update last login time
        final updatedUser = existingUser.copyWith(updatedAt: DateTime.now());
        await _saveUserToFirestore(updatedUser);
        return Right(updatedUser);
      } else {
        // Create new user
        final userModel = UserModel.fromFirebaseUser(userCredential.user!);
        await _saveUserToFirestore(userModel);
        return Right(userModel);
      }
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getAuthErrorMessage(e.code)));
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Firestore error occurred'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Reset password
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getAuthErrorMessage(e.code)));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Sign out
  Future<Either<Failure, void>> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Update user profile
  Future<Either<Failure, UserModel>> updateUserProfile({
    String? displayName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    File? profileImage,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        return Left(AuthFailure('No user signed in'));
      }

      // Get current user data
      UserModel? currentUserModel = await _getUserFromFirestore(user.uid);
      if (currentUserModel == null) {
        return Left(FirestoreFailure('User data not found'));
      }

      String? photoURL = currentUserModel.photoURL;

      // Upload new profile image if provided
      if (profileImage != null) {
        photoURL = await _uploadProfileImage(user.uid, profileImage);
        await user.updatePhotoURL(photoURL);
      }

      // Update display name in Firebase Auth
      if (displayName != null && displayName != user.displayName) {
        await user.updateDisplayName(displayName);
      }

      // Update user models
      final updatedUserModel = currentUserModel.copyWith(
        displayName: displayName,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        photoURL: photoURL,
      );

      // Save to Firestore
      await _saveUserToFirestore(updatedUserModel);

      return Right(updatedUserModel);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getAuthErrorMessage(e.code)));
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Firestore error occurred'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    final user = currentUser;
    if (user == null) return null;

    return await _getUserFromFirestore(user.uid);
  }

  // Private helper methods

  // Upload profile image to Firebase Storage
  Future<String> _uploadProfileImage(String userId, File imageFile) async {
    final ref = _storage.ref().child(AppConstants.profileImagesFolder).child('$userId.jpg');

    final uploadTask = ref.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Save user data to Firestore
  Future<void> _saveUserToFirestore(UserModel userModel) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userModel.id)
        .set(userModel.toFirestore(), SetOptions(merge: true));
  }

  // Get user data from Firestore
  Future<UserModel?> _getUserFromFirestore(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get user-friendly error messages
  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}