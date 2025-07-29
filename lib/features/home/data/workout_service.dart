import 'package:cloud_firestore/cloud_firestore.dart';
import 'workout_routine_model.dart';

class WorkoutService {
  final FirebaseFirestore _firestore;
  WorkoutService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<WorkoutRoutine>> fetchWorkouts() async {
    final snapshot = await _firestore.collection('workout_routines').get();
    return snapshot.docs.map((doc) => WorkoutRoutine.fromMap(doc.data(), doc.id)).toList();
  }
} 