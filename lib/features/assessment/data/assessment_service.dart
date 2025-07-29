import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failures.dart';
import 'package:hive/hive.dart';
import 'assessment_model.dart';

class AssessmentService {
  final FirebaseFirestore _firestore;
  final String _boxName = 'assessmentsBox';

  AssessmentService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance {
    // Enable offline persistence
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: AppConstants.maxCacheSize,
    );
  }

  Future<Box<AssessmentModel>> _openBox() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(AssessmentModelAdapter());
    }
    return await Hive.openBox<AssessmentModel>(_boxName);
  }

  // Get assessments with offline support and local Hive cache
  Future<Either<Failure, List<AssessmentModel>>> getAssessments({
    int limit = AppConstants.defaultPageSize,
    String? category,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore
          .collection(AppConstants.assessmentsCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true);

      // Filter by category if provided
      if (category != null && category.isNotEmpty && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      // Add pagination
      query = query.limit(limit);
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get(const GetOptions(
        source: Source.server,
      ));

      final assessments = querySnapshot.docs
          .map((doc) => AssessmentModel.fromFirestore(doc))
          .toList();

      // Save to Hive
      final box = await _openBox();
      await box.clear();
      for (final assessment in assessments) {
        await box.put(assessment.id, assessment);
      }

      return Right(assessments);
    } on FirebaseException catch (e) {
      // On error, try loading from Hive
      final box = await _openBox();
      final local = box.values.toList();
      if (local.isNotEmpty) {
        return Right(local);
      }
      return Left(FirestoreFailure(e.message ?? 'Failed to fetch assessments'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Sync local Hive data to Firestore (if needed)
  Future<void> syncLocalToRemote() async {
    final box = await _openBox();
    final localAssessments = box.values.toList();
    for (final assessment in localAssessments) {
      await _firestore
          .collection(AppConstants.assessmentsCollection)
          .doc(assessment.id)
          .set(assessment.toFirestore(), SetOptions(merge: true));
    }
  }

  // Get recent assessments for home page (limit 2)
  Future<Either<Failure, List<AssessmentModel>>> getRecentAssessments() async {
    return getAssessments();
  }

  // Get assessment by ID
  Future<Either<Failure, AssessmentModel>> getAssessmentById(String id) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.assessmentsCollection)
          .doc(id)
          .get(const GetOptions(source: Source.cache))
          .catchError((_) async {
        return await _firestore
            .collection(AppConstants.assessmentsCollection)
            .doc(id)
            .get(const GetOptions(source: Source.server));
      });

      if (!doc.exists) {
        return Left(FirestoreFailure('Assessment not found'));
      }

      final assessment = AssessmentModel.fromFirestore(doc);
      return Right(assessment);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Failed to fetch assessment'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Get categories
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.assessmentsCollection)
          .where('isActive', isEqualTo: true)
          .get(const GetOptions(source: Source.cache))
          .catchError((_) async {
        return await _firestore
            .collection(AppConstants.assessmentsCollection)
            .where('isActive', isEqualTo: true)
            .get(const GetOptions(source: Source.server));
      });

      final categories = <String>{'All'};
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        if (data['category'] != null) {
          categories.add(data['category'] as String);
        }
      }

      return Right(categories.toList());
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Failed to fetch categories'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Search assessments (case-insensitive using titleLower field)
  Future<Either<Failure, List<AssessmentModel>>> searchAssessments(
      String query, {
        int limit = AppConstants.defaultPageSize,
        DocumentSnapshot? lastDocument,
      }) async {
    try {
      final lowerQuery = query.toLowerCase();
      Query firestoreQuery = _firestore
          .collection(AppConstants.assessmentsCollection)
          .where('isActive', isEqualTo: true)
          .where('titleLower', isGreaterThanOrEqualTo: lowerQuery)
          .where('titleLower', isLessThanOrEqualTo: '$lowerQuery\uf8ff')
          .limit(limit);
      if (lastDocument != null) {
        firestoreQuery = firestoreQuery.startAfterDocument(lastDocument);
      }
      final querySnapshot = await firestoreQuery
          .get(const GetOptions(source: Source.cache))
          .catchError((_) async {
        return await firestoreQuery
            .get(const GetOptions(source: Source.server));
      });

      final assessments = querySnapshot.docs
          .map((doc) => AssessmentModel.fromFirestore(doc))
          .toList();

      return Right(assessments);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(e.message ?? 'Failed to search assessments'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Stream assessments for real-time updates
  Stream<List<AssessmentModel>> getAssessmentsStream({
    int limit = AppConstants.defaultPageSize,
    String? category,
  }) {
    Query query = _firestore
        .collection(AppConstants.assessmentsCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true);

    if (category != null && category.isNotEmpty && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    return query.limit(limit).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AssessmentModel.fromFirestore(doc))
          .toList();
    });
  }

  // Save or update a single assessment locally
  Future<void> saveAssessmentLocally(AssessmentModel assessment) async {
    final box = await _openBox();
    await box.put(assessment.id, assessment);
  }
}