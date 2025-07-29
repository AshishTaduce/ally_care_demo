import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../../data/assessment_service.dart';
import '../../data/assessment_model.dart';

// Assessment service provider
final assessmentServiceProvider = Provider<AssessmentService>((ref) {
  return AssessmentService();
});

// Assessments provider (for home page)
final recentAssessmentsProvider = FutureProvider<List<AssessmentModel>>((ref) async {
  final service = ref.watch(assessmentServiceProvider);
  final result = await service.getRecentAssessments();

  return result.fold(
        (failure) => throw Exception(failure.message),
        (assessments) => assessments,
  );
});

// All assessments provider (for assessment list page)
final assessmentsProvider = FutureProvider.family<List<AssessmentModel>, String?>((ref, category) async {
  final service = ref.watch(assessmentServiceProvider);
  final result = await service.getAssessments(category: category);

  return result.fold(
        (failure) => throw Exception(failure.message),
        (assessments) => assessments,
  );
});

// Assessment categories provider
final assessmentCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.watch(assessmentServiceProvider);
  final result = await service.getCategories();

  return result.fold(
        (failure) => throw Exception(failure.message),
        (categories) => categories,
  );
});

// Assessment by ID provider
final assessmentByIdProvider = FutureProvider.family<AssessmentModel, String>((ref, id) async {
  final service = ref.watch(assessmentServiceProvider);
  final result = await service.getAssessmentById(id);

  return result.fold(
        (failure) => throw Exception(failure.message),
        (assessment) => assessment,
  );
});

// Assessment search provider
final assessmentSearchProvider = FutureProvider.family<List<AssessmentModel>, String>((ref, query) async {
  if (query.isEmpty) return [];

  final service = ref.watch(assessmentServiceProvider);
  final result = await service.searchAssessments(query);

  return result.fold(
        (failure) => throw Exception(failure.message),
        (assessments) => assessments,
  );
});

// Selected category provider for filtering
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Paginated assessments provider
class PaginatedAssessmentsNotifier extends AsyncNotifier<List<AssessmentModel>> {
  List<AssessmentModel> _assessments = [];
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> fetchNext({int limit = 25, String? category}) async {
    if (!_hasMore) return;
    final service = ref.read(assessmentServiceProvider);
    final result = await service.getAssessments(
      limit: limit,
      category: category,
      lastDocument: _lastDocument,
    );
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (assessments) {
        if (assessments.length < limit) _hasMore = false;
        if (assessments.isNotEmpty) {
          _lastDocument = null;
          // Find last doc
          final last = assessments.last;
          // This assumes AssessmentModel has a reference to the original doc, otherwise you need to pass doc snapshot
        }
        _assessments.addAll(assessments);
        state = AsyncData(_assessments);
      },
    );
  }

  @override
  FutureOr<List<AssessmentModel>> build() async {
    _assessments = [];
    _lastDocument = null;
    _hasMore = true;
    await fetchNext();
    return _assessments;
  }
}

final paginatedAssessmentsProvider = AsyncNotifierProvider<PaginatedAssessmentsNotifier, List<AssessmentModel>>(
  PaginatedAssessmentsNotifier.new,
);

// Paginated search provider
class PaginatedAssessmentSearchNotifier extends AsyncNotifier<List<AssessmentModel>> {
  List<AssessmentModel> _assessments = [];
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  String _query = '';

  Future<void> searchNext({required String query, int limit = 25}) async {
    if (!_hasMore || query != _query) {
      _assessments = [];
      _lastDocument = null;
      _hasMore = true;
      _query = query;
    }
    final service = ref.read(assessmentServiceProvider);
    final result = await service.searchAssessments(
      query,
      limit: limit,
      lastDocument: _lastDocument,
    );
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (assessments) {
        if (assessments.length < limit) _hasMore = false;
        if (assessments.isNotEmpty) {
          _lastDocument = null;
        }
        _assessments.addAll(assessments);
        state = AsyncData(_assessments);
      },
    );
  }

  @override
  FutureOr<List<AssessmentModel>> build() async {
    return _assessments;
  }
}

final paginatedAssessmentSearchProvider = AsyncNotifierProvider<PaginatedAssessmentSearchNotifier, List<AssessmentModel>>(
  PaginatedAssessmentSearchNotifier.new,
);