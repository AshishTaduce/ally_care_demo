import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/workout_service.dart';
import '../../data/workout_routine_model.dart';

class WorkoutState {
  final List<WorkoutRoutine> workouts;
  final bool isLoading;
  final String? error;

  WorkoutState({
    this.workouts = const [],
    this.isLoading = false,
    this.error,
  });

  WorkoutState copyWith({
    List<WorkoutRoutine>? workouts,
    bool? isLoading,
    String? error,
  }) {
    return WorkoutState(
      workouts: workouts ?? this.workouts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class WorkoutNotifier extends StateNotifier<WorkoutState> {
  final WorkoutService _service;
  WorkoutNotifier(this._service) : super(WorkoutState());

  Future<void> fetchWorkouts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final workouts = await _service.fetchWorkouts();
      state = state.copyWith(workouts: workouts, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final workoutProvider = StateNotifierProvider<WorkoutNotifier, WorkoutState>((ref) {
  final service = WorkoutService();
  final notifier = WorkoutNotifier(service);
  notifier.fetchWorkouts();
  return notifier;
}); 