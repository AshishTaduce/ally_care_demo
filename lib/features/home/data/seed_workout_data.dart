import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedWorkoutRoutines() async {
  final firestore = FirebaseFirestore.instance;
  final routines = [
    {
      'title': 'Sweat Starter',
      'type': 'Full Body',
      'imageUrl': 'https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg',
      'tag': 'Lose Weight',
      'difficulty': 'Medium',
      'description': 'A full body workout to get you sweating and burning calories.',
    },
    {
      'title': 'Strength Builder',
      'type': 'Upper Body',
      'imageUrl': 'https://images.pexels.com/photos/2261482/pexels-photo-2261482.jpeg',
      'tag': 'Build Muscle',
      'difficulty': 'Hard',
      'description': 'Focus on upper body strength and muscle gain.',
    },
    {
      'title': 'Flexibility Flow',
      'type': 'Stretching',
      'imageUrl': 'https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg',
      'tag': 'Flexibility',
      'difficulty': 'Easy',
      'description': 'Improve your flexibility with guided stretching routines.',
    },
  ];
  for (final routine in routines) {
    await firestore.collection('workout_routines').add(routine);
  }
  print('Seeded workout routines!');
} 